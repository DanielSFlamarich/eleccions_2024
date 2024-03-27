WITH PARAMS AS (
    SELECT to_date('%s', 'YYYY-MM-DD') start_date
)
SELECT
    DATE(mc.created_at) AS date,
    (CASE
        mc.product_id WHEN mc.product_id = 1 THEN 'primary'
        ELSE 'upsells'
        END) AS product_type,
    COUNT(DISTINCT mc.membership_id) AS transactions,
    ROUND(SUM((mc.amount * COALESCE(cc.usd_conversion_rate,1))),0) AS gross_revenue_usd,
    ROUND((ROUND(SUM((mc.amount * COALESCE(cc.usd_conversion_rate,1))),0) / COUNT(DISTINCT mc.membership_id)),2) AS aov
FROM
    kb.membership_created AS mc
LEFT JOIN kb.user_registered ur ON
    ur.user_id = mc.user_id
LEFT JOIN etl.currency_conversions cc ON
    (DATE(cc.date_cest) = (DATE(mc.created_at))
    AND (DATE_PART(hour, mc.created_at) = cc.hour_cest)
    AND (cc.currency = mc.currency)),
params
WHERE
    mc.created_at >= params.start_date
    AND ur.email NOT LIKE '%%@teamcmp.com'
    AND ur.email NOT LIKE '%%@moarmarketing.com'
GROUP BY
    DATE(mc.created_at),
    (CASE
        mc.product_id WHEN mc.product_id = 1 THEN 'primary'
        ELSE 'upsells'
        END)
ORDER BY 
    DATE(mc.created_at) DESC,
    product_type ASC