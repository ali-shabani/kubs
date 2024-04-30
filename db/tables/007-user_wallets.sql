CREATE TABLE "user_wallets" (
    "type" CITEXT NOT NULL,
    "priority" INTEGER NOT NULL CHECK (priority > 0),
    "user_id" INTEGER NOT NULL,
    "wallet_id" UUID PRIMARY KEY NOT NULL,

    CONSTRAINT "user_wallets_type_unique" UNIQUE ("user_id","type"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY ("wallet_id") REFERENCES "wallets"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);