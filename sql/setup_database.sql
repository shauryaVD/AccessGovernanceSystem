-- Create Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    department TEXT,
    manager TEXT,
    hire_date DATE,
    termination_date DATE,
    employment_status TEXT CHECK(employment_status IN ('Active', 'Terminated'))
);

-- Create Roles Table
CREATE TABLE IF NOT EXISTS roles (
    role_id INTEGER PRIMARY KEY,
    role_name TEXT UNIQUE NOT NULL,
    description TEXT,
    risk_level TEXT CHECK(risk_level IN ('Low', 'Medium', 'High', 'Critical'))
);

-- Create User_Roles Table
CREATE TABLE IF NOT EXISTS user_roles (
    user_role_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    assigned_date DATE,
    last_reviewed_date DATE,
    reviewed_by TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Create Data Quality Issues Table
CREATE TABLE IF NOT EXISTS data_quality_issues (
    issue_id INTEGER PRIMARY KEY AUTOINCREMENT,
    check_type TEXT NOT NULL,
    severity TEXT CHECK(severity IN ('CRITICAL', 'HIGH', 'WARNING', 'INFO')),
    affected_user_id INTEGER,
    issue_details TEXT,
    detected_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'OPEN' CHECK(status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'FALSE_POSITIVE')),
    resolved_date DATETIME,
    resolution_notes TEXT
);