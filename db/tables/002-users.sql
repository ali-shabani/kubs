CREATE TABLE users (
   id SERIAL NOT NULL PRIMARY KEY,
   uid UUID NOT NULL DEFAULT uuid_generate_v4(),
   created_at TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
   first_name TEXT,
   last_name TEXT,
   is_active BOOLEAN NOT NULL DEFAULT TRUE,
   mobile CITEXT UNIQUE CHECK (mobile ~ '^\+989\d{9}$'),
   email CITEXT UNIQUE CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
   password TEXT,
   organization_id UUID REFERENCES organizations(id) ON DELETE SET NULL,

   CONSTRAINT mobile_or_email_required CHECK (mobile IS NOT NULL OR email IS NOT NULL)
);