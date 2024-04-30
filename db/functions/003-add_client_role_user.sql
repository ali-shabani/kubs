CREATE OR REPLACE FUNCTION add_client_role_user()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO role_users (user_id, role_id)
    VALUES (NEW.id, get_client_role_id());

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER add_client_role_user_trigger
    AFTER INSERT ON users
    FOR EACH ROW EXECUTE PROCEDURE add_client_role_user();