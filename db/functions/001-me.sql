CREATE OR REPLACE FUNCTION me(hasura_session json)
    RETURNS users AS
$$
SELECT *
FROM users
WHERE "id" = CAST(hasura_session ->> 'x-hasura-user-id' AS INT)
limit 1
$$ LANGUAGE sql STABLE;