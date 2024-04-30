CREATE OR REPLACE FUNCTION get_client_role_id()
    RETURNS INT AS
$$
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
$$ LANGUAGE plpgsql;