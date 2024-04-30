CREATE TABLE "wallet_transactions" (
    "id" UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_increase" BOOLEAN NOT NULL,
    "amount" INTEGER NOT NULL CHECK (amount > 0),
    "before" INTEGER NOT NULL,
    "after" INTEGER NOT NULL,
    "wallet_id" UUID NOT NULL,
    "payload" JSONB,

    FOREIGN KEY ("wallet_id") REFERENCES "wallets"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX wallet_transactions_created_at_idx ON wallet_transactions(created_at);
CREATE INDEX wallet_transactions_is_increase_idx ON wallet_transactions(is_increase);
CREATE INDEX wallet_transactions_amount_idx ON wallet_transactions(amount);
CREATE INDEX wallet_transactions_payload_idx ON wallet_transactions USING GIN(payload);