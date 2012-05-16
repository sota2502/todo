CREATE TABLE task (
    task_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title VARCHAR(40),
    description TEXT,
    status TINYINT(3) DEFAULT 0,
    created_at timestamp,
    updated_at timestamp
);
CREATE INDEX task_idx1 ON task (user_id);
CREATE INDEX task_idx2 ON task (user_id, status, updated_at);
