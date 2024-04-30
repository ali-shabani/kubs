CREATE TABLE credit_packs (
    "id" UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "amount" INTEGER NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT TRUE
);