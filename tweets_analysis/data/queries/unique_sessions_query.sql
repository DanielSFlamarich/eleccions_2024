WITH PARAMS AS (
    SELECT to_date('%s', 'YYYY-MM-DD') start_date
)
SELECT
    DATE(ts.submitted_at) AS date,
    COUNT(DISTINCT ts.session_id) AS unique_sessions
FROM
    kb.tour_steps AS ts, params
WHERE
    ts.tour_step = 0
    AND ts.submitted_at >= params.start_date
GROUP BY
    DATE(ts.submitted_at)
ORDER BY
    DATE(ts.submitted_at) DESC