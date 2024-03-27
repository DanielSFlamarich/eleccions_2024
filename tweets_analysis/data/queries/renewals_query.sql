WITH PARAMS AS (
    SELECT to_date('%s', 'YYYY-MM-DD') start_date
)
SELECT
    DATE(t."date") AS renewal_date,
    COUNT(DISTINCT t.transaction_id) AS renewals
FROM
    kb.recurly_transactions AS t
LEFT JOIN kb.recurly_accounts AS ra ON ra.account_code = t.account_code,
params
WHERE
    t.origin = 'recurring'
    AND t.status = 'success'
    AND t."date" >= params.start_date
    AND ra.account_email NOT LIKE '%%@teamcmp.com'
    AND ra.account_email NOT LIKE '%%@moarmarketing.com'
GROUP BY
    DATE(t."date")
ORDER BY
    DATE(t."date") DESC