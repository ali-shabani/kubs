CREATE TABLE organizations (
   id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
   created_at TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
   name TEXT NOT NULL UNIQUE
);