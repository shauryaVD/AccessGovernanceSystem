-- Orphaned Accounts Check: Find terminated employees with active role assignments
SELECT 
    u.user_id,
    u.name,
    u.email,
    u.termination_date,
    COUNT(ur.role_id) as active_roles,
    GROUP_CONCAT(r.role_name, ', ') as roles_list,
    CAST((julianday('now') - julianday(u.termination_date)) AS INTEGER) as days_since_termination,
    'CRITICAL' as severity,
    'Orphaned Account - Terminated employee with active access' as issue_type
FROM users u
JOIN user_roles ur ON u.user_id = ur.user_id
JOIN roles r ON ur.role_id = r.role_id
WHERE u.employment_status = 'Terminated'
GROUP BY u.user_id, u.name, u.email, u.termination_date
ORDER BY u.termination_date DESC;