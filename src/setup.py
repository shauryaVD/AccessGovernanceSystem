#!/usr/bin/env python3
"""
Setup script for Access Governance System
Creates SQLite database and loads sample data
"""

import sqlite3
import csv
import os

def setup_database():
    """Create database and tables"""
    # Connect to database (creates if doesn't exist)
    conn = sqlite3.connect('access_governance.db')
    cursor = conn.cursor()
    
    print("Creating database schema...")
    
    # Read and execute schema SQL
    with open('sql/setup_database.sql', 'r') as f:
        schema_sql = f.read()
        cursor.executescript(schema_sql)
    
    print("✓ Database schema created")
    
    # Load CSV data
    print("\nLoading sample data...")
    
    # Load users
    with open('data/users.csv', 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            cursor.execute('''
                INSERT OR REPLACE INTO users 
                (user_id, name, email, department, manager, hire_date, termination_date, employment_status)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ''', (row['user_id'], row['name'], row['email'], row['department'], 
                  row['manager'], row['hire_date'], 
                  row['termination_date'] if row['termination_date'] else None,
                  row['employment_status']))
    print(f"✓ Loaded {cursor.rowcount} users")
    
    # Load roles
    with open('data/roles.csv', 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            cursor.execute('''
                INSERT OR REPLACE INTO roles 
                (role_id, role_name, description, risk_level)
                VALUES (?, ?, ?, ?)
            ''', (row['role_id'], row['role_name'], row['description'], row['risk_level']))
    print(f"✓ Loaded {cursor.rowcount} roles")
    
    # Load user_roles
    with open('data/user_roles.csv', 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            cursor.execute('''
                INSERT OR REPLACE INTO user_roles 
                (user_role_id, user_id, role_id, assigned_date, last_reviewed_date, reviewed_by)
                VALUES (?, ?, ?, ?, ?, ?)
            ''', (row['user_role_id'], row['user_id'], row['role_id'], 
                  row['assigned_date'],
                  row['last_reviewed_date'] if row['last_reviewed_date'] else None,
                  row['reviewed_by'] if row['reviewed_by'] else None))
    print(f"✓ Loaded {cursor.rowcount} user-role assignments")
    
    conn.commit()
    conn.close()
    
    print("\n✓ Database setup complete!")
    print("Database file: access_governance.db")

if __name__ == "__main__":
    setup_database()