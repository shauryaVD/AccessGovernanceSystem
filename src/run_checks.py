#!/usr/bin/env python3
"""
Run all access governance quality checks
"""

import sqlite3
import os
from datetime import datetime

def run_check(conn, check_name, sql_file):
    """Run a single check and display results"""
    print(f"\n{'='*60}")
    print(f"CHECK: {check_name}")
    print(f"{'='*60}")
    
    with open(sql_file, 'r') as f:
        query = f.read()
    
    cursor = conn.cursor()
    cursor.execute(query)
    
    results = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    
    if not results:
        print("✓ No issues found")
        return 0
    
    print(f"\n⚠️  Found {len(results)} issue(s):\n")
    
    for row in results:
        for col, val in zip(columns, row):
            print(f"  {col}: {val}")
        print()
    
    return len(results)

def main():
    """Run all checks"""
    if not os.path.exists('access_governance.db'):
        print("❌ Database not found. Run setup.py first!")
        return
    
    conn = sqlite3.connect('access_governance.db')
    
    print("\nACCESS GOVERNANCE QUALITY CHECKS")
    print(f"Run Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    total_issues = 0
    
    # Run each check
    checks = [
        ("Stale Access (90+ days)", "sql/check_stale_access.sql"),
        ("Privilege Creep (5+ roles)", "sql/check_privilege_creep.sql"),
        ("Orphaned Accounts", "sql/check_orphaned_accounts.sql"),
        ("Segregation of Duties Conflicts", "sql/check_sod_conflicts.sql")
    ]
    
    for check_name, sql_file in checks:
        issues = run_check(conn, check_name, sql_file)
        total_issues += issues
    
    print(f"\n{'='*60}")
    print(f"SUMMARY: {total_issues} total issues found")
    print(f"{'='*60}\n")
    
    conn.close()

if __name__ == "__main__":
    main()
