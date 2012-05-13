CREATE TABLE user (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    password CHAR(40),
    email VARCHAR(255)
);
CREATE UNIQUE INDEX idx1 ON user (email);
