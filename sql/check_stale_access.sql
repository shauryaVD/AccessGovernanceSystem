-- Stale Access Check: Find role assignments not reviewed in 90+ days
SELECT 
    u.user_id,
    u.name,
    u.email,
    r.role_name,
    ur.last_reviewed_date,
    CAST((julianday('now') - julianday(ur.last_reviewed_date)) AS INTEGER) as days_since_review,
    CASE 
        WHEN ur.last_reviewed_date IS NULL THEN 'CRITICAL'
        WHEN (julianday('now') - julianday(ur.last_reviewed_date)) > 180 THEN 'CRITICAL'
        WHEN (julianday('now') - julianday(ur.last_reviewed_date)) > 90 THEN 'WARNING'
        ELSE 'OK'
    END as severity,
    'Stale Access - Not reviewed in 90+ days' as issue_type
FROM users u
JOIN user_roles ur ON u.user_id = ur.user_id
JOIN roles r ON ur.role_id = r.role_id
WHERE u.employment_status = 'Active'
    AND (ur.last_reviewed_date IS NULL 
         OR (julianday('now') - julianday(ur.last_reviewed_date)) > 90)
ORDER BY days_since_review DESC;