CREATE TABLE role_users (
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,

    CONSTRAINT role_users_pkey PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE
);