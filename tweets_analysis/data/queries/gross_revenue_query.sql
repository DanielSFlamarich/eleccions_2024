WITH PARAMS AS (
    SELECT to_date('%s', 'YYYY-MM-DD') start_date
)
SELECT
    DATE(mc.created_at) AS date,
    ROUND(SUM((mc.amount * COALESCE(cc.usd_conversion_rate,1))),0) AS gross_revenue_usd
FROM
    kb.membership_created AS mc
LEFT JOIN kb.user_registered AS ur ON ur.user_id = mc.user_id
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
    DATE(mc.created_at)
ORDER BY 
    DATE(mc.created_at) DESC