WITH PARAMS AS (
    SELECT to_date('%s', 'YYYY-MM-DD') start_date
)
SELECT
    DATE(mc.created_at) AS date,
    COUNT(DISTINCT mc.membership_id) AS upsells
FROM
    kb.membership_created AS mc
LEFT JOIN kb.user_registered AS ur ON ur.user_id = mc.user_id,
params
WHERE
    mc.product_id != 1
    AND mc.created_at >= params.start_date
    AND ur.email NOT LIKE '%%@teamcmp.com'
    AND ur.email NOT LIKE '%%@moarmarketing.com'
GROUP BY
    DATE(mc.created_at)
ORDER BY 
    DATE(mc.created_at) DESC