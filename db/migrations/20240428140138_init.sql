-- Create "get_client_role_id" function
CREATE FUNCTION "public"."get_client_role_id" () RETURNS integer LANGUAGE plpgsql AS $$
DECLARE
    role_id INT;
BEGIN
    SELECT id INTO role_id FROM roles WHERE name = 'client';

    IF role_id IS NULL THEN
        INSERT INTO roles (name)
        VALUES ('client')
        RETURNING id INTO role_id;
    END IF;

    RETURN role_id;
END
$$;
-- Create extension "uuid-ossp"
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "public" VERSION "1.1";
-- Create "credit_packs" table
CREATE TABLE "public"."credit_packs" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "name" text NOT NULL,
  "description" text NULL,
  "amount" integer NOT NULL,
  "is_active" boolean NOT NULL DEFAULT true,
  PRIMARY KEY ("id")
);
-- Create "roles" table
CREATE TABLE "public"."roles" (
  "id" serial NOT NULL,
  "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "name" text NOT NULL,
  PRIMARY KEY ("id")
);
-- Create extension "citext"
CREATE EXTENSION IF NOT EXISTS "citext" WITH SCHEMA "public" VERSION "1.6";
-- Create "add_client_role_user" function
CREATE FUNCTION "public"."add_client_role_user" () RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO role_users (user_id, role_id)
    VALUES (NEW.id, get_client_role_id());

    RETURN NEW;
END;
$$;
-- Create "organizations" table
CREATE TABLE "public"."organizations" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "name" text NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "organizations_name_key" UNIQUE ("name")
);
-- Create "users" table
CREATE TABLE "public"."users" (
  "id" serial NOT NULL,
  "uid" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "first_name" text NULL,
  "last_name" text NULL,
  "is_active" boolean NOT NULL DEFAULT true,
  "mobile" citext NULL,
  "email" citext NULL,
  "password" text NULL,
  "organization_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "users_email_key" UNIQUE ("email"),
  CONSTRAINT "users_mobile_key" UNIQUE ("mobile"),
  CONSTRAINT "users_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "mobile_or_email_required" CHECK ((mobile IS NOT NULL) OR (email IS NOT NULL)),
  CONSTRAINT "users_email_check" CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::citext),
  CONSTRAINT "users_mobile_check" CHECK (mobile ~ '^\+989\d{9}$'::citext)
);
-- Create trigger "add_client_role_user_trigger"
CREATE TRIGGER "add_client_role_user_trigger" AFTER INSERT ON "public"."users" FOR EACH ROW EXECUTE FUNCTION "public"."add_client_role_user"();
-- Create "me" function
CREATE FUNCTION "public"."me" ("hasura_session" json) RETURNS users LANGUAGE sql STABLE AS $$
SELECT *
FROM users
WHERE "id" = CAST(hasura_session ->> 'x-hasura-user-id' AS INT)
limit 1
$$;
-- Create "role_users" table
CREATE TABLE "public"."role_users" (
  "user_id" integer NOT NULL,
  "role_id" integer NOT NULL,
  PRIMARY KEY ("user_id", "role_id"),
  CONSTRAINT "role_users_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "role_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- Create "wallets" table
CREATE TABLE "public"."wallets" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "balance" integer NOT NULL DEFAULT 0,
  "min" integer NOT NULL DEFAULT 0,
  PRIMARY KEY ("id")
);
-- Create "user_wallets" table
CREATE TABLE "public"."user_wallets" (
  "type" citext NOT NULL,
  "priority" integer NOT NULL,
  "user_id" integer NOT NULL,
  "wallet_id" uuid NOT NULL,
  PRIMARY KEY ("wallet_id"),
  CONSTRAINT "user_wallets_type_unique" UNIQUE ("user_id", "type"),
  CONSTRAINT "user_wallets_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "user_wallets_wallet_id_fkey" FOREIGN KEY ("wallet_id") REFERENCES "public"."wallets" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "user_wallets_priority_check" CHECK (priority > 0)
);
-- Create "wallet_transactions" table
CREATE TABLE "public"."wallet_transactions" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "is_increase" boolean NOT NULL,
  "amount" integer NOT NULL,
  "before" integer NOT NULL,
  "after" integer NOT NULL,
  "wallet_id" uuid NOT NULL,
  "payload" jsonb NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "wallet_transactions_wallet_id_fkey" FOREIGN KEY ("wallet_id") REFERENCES "public"."wallets" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "wallet_transactions_amount_check" CHECK (amount > 0)
);
-- Create index "wallet_transactions_amount_idx" to table: "wallet_transactions"
CREATE INDEX "wallet_transactions_amount_idx" ON "public"."wallet_transactions" ("amount");
-- Create index "wallet_transactions_created_at_idx" to table: "wallet_transactions"
CREATE INDEX "wallet_transactions_created_at_idx" ON "public"."wallet_transactions" ("created_at");
-- Create index "wallet_transactions_is_increase_idx" to table: "wallet_transactions"
CREATE INDEX "wallet_transactions_is_increase_idx" ON "public"."wallet_transactions" ("is_increase");
-- Create index "wallet_transactions_payload_idx" to table: "wallet_transactions"
CREATE INDEX "wallet_transactions_payload_idx" ON "public"."wallet_transactions" USING gin ("payload");
