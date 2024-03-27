WITH PARAMS AS (
    SELECT to_date('%s', 'YYYY-MM-DD') start_date
)
SELECT
    DATE(mc.created_at) AS date,
    mc.product_id,
    p.name AS product_name,
    (CASE
        mc.product_id WHEN mc.product_id = 8 THEN 12.05
        WHEN mc.product_id = 9 THEN 29.90
        WHEN mc.product_id = 10 THEN 44.50
    END) AS cost_per_unit,
    COUNT(DISTINCT mc.membership_id) AS kcollagen_units_sold
FROM
    kb.membership_created AS mc
LEFT JOIN kb.user_registered ur ON ur.user_id = mc.user_id
LEFT JOIN kb.products p ON p.id = mc.product_id,
params
WHERE
    mc.product_id IN (8, 9, 10)
    AND mc.created_at >= params.start_date
    AND ur.email NOT LIKE '%%@teamcmp.com'
    AND ur.email NOT LIKE '%%@moarmarketing.com'
GROUP BY
    DATE(mc.created_at),
    mc.product_id,
    p.name
ORDER BY
    DATE(mc.created_at) DESC,
    mc.product_id ASC