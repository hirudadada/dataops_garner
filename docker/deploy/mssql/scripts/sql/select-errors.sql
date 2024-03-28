-- Count of spans that has error
SELECT
  NAME,
  SUM(CASE WHEN ERROR IS NULL THEN 1 ELSE 0 END) AS step_no_error_count,
  SUM(CASE WHEN ERROR IS NOT NULL THEN 1 ELSE 0 END) AS step_has_error_count
FROM (
  SELECT js.ERROR, jl.NAME
  FROM JOB_STEP_LOGS AS js
  INNER JOIN JOB_LOGS AS jl
  ON js.JOB_LOG_ID = jl.ID
) AS JobData
GROUP BY
  NAME;

-- Count of transactions that has error
SELECT
  jl.NAME,
  COUNT(DISTINCT CASE WHEN js.ERROR IS NULL THEN jl.ID ELSE NULL END) AS log_no_error_count,
  COUNT(DISTINCT CASE WHEN js.ERROR IS NOT NULL THEN jl.ID ELSE NULL END) AS log_has_error_count
FROM
  JOB_LOGS AS jl
LEFT JOIN JOB_STEP_LOGS AS js
  ON jl.ID = js.JOB_LOG_ID
GROUP BY
  jl.NAME;

-- -- Transactions that have error happened more than once
-- -- group by transaction name
-- SELECT jl.NAME, count(*) AS transactions
-- FROM (
--   SELECT 
--     JOB_LOG_ID, COUNT(*) AS ErrorCount
--   FROM JOB_STEP_LOGS
--   WHERE ERROR IS NOT NULL
--   GROUP BY JOB_LOG_ID
--   -- HAVING COUNT(*) >= 1
-- ) AS e
-- INNER JOIN JOB_LOGS as jl
-- ON e.JOB_LOG_ID = jl.ID
-- GROUP BY jl.NAME
--
