-- Privilege Creep Check: Find users with excessive role assignments
SELECT 
    u.user_id,
    u.name,
    u.email,
    u.department,
    COUNT(ur.role_id) as role_count,
    GROUP_CONCAT(r.role_name, ', ') as roles_list,
    CASE 
        WHEN COUNT(ur.role_id) >= 8 THEN 'CRITICAL'
        WHEN COUNT(ur.role_id) >= 5 THEN 'WARNING'
        ELSE 'OK'
    END as severity,
    'Privilege Creep - Excessive role assignments' as issue_type
FROM users u
JOIN user_roles ur ON u.user_id = ur.user_id
JOIN roles r ON ur.role_id = r.role_id
WHERE u.employment_status = 'Active'
GROUP BY u.user_id, u.name, u.email, u.department
HAVING COUNT(ur.role_id) >= 5
ORDER BY role_count DESC; 