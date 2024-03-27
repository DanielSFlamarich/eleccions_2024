WITH PARAMS AS (
    SELECT to_date('%s', 'YYYY-MM-DD') start_date
)
SELECT
    DATE(a.date) AS date,
    ROUND(SUM(a.adspent),2) AS adspent
FROM
    funnel_io.adspent AS a,
params
WHERE
    a.product_name = 'KetoBody'
    AND a.date >= params.start_date
GROUP BY
    DATE(a.date)
ORDER BY
    DATE(a.date) DESC