-- Segregation of Duties Conflicts: Find users with incompatible role combinations
SELECT 
    u.user_id,
    u.name,
    u.email,
    r1.role_name as role_1,
    r2.role_name as role_2,
    'CRITICAL' as severity,
    'Segregation of Duties Violation - Incompatible roles' as issue_type,
    CASE 
        WHEN r1.role_name = 'Trader' AND r2.role_name = 'Trade_Approver' 
            THEN 'Cannot both initiate and approve trades'
        WHEN r1.role_name = 'Payment_Initiator' AND r2.role_name = 'Payment_Approver' 
            THEN 'Cannot both initiate and approve payments'
        WHEN r1.role_name = 'Account_Creator' AND r2.role_name = 'Account_Approver' 
            THEN 'Cannot both create and approve accounts'
        ELSE 'Incompatible role combination'
    END as conflict_description
FROM users u
JOIN user_roles ur1 ON u.user_id = ur1.user_id
JOIN roles r1 ON ur1.role_id = r1.role_id
JOIN user_roles ur2 ON u.user_id = ur2.user_id
JOIN roles r2 ON ur2.role_id = r2.role_id
WHERE u.employment_status = 'Active'
    AND r1.role_id < r2.role_id
    AND (
        (r1.role_name = 'Trader' AND r2.role_name = 'Trade_Approver')
        OR (r1.role_name = 'Trade_Approver' AND r2.role_name = 'Trader')
        OR (r1.role_name = 'Payment_Initiator' AND r2.role_name = 'Payment_Approver')
        OR (r1.role_name = 'Payment_Approver' AND r2.role_name = 'Payment_Initiator')
        OR (r1.role_name = 'Account_Creator' AND r2.role_name = 'Account_Approver')
        OR (r1.role_name = 'Account_Approver' AND r2.role_name = 'Account_Creator')
    )
ORDER BY u.name;