-- Count of spans that has error
SELECT
  ETL_PROCEDURE,
  SUM(CASE WHEN ERRORMSG IS NULL THEN 1 ELSE 0 END) AS step_no_error_count,
  SUM(CASE WHEN ERRORMSG IS NOT NULL THEN 1 ELSE 0 END) AS step_has_error_count
FROM (
  SELECT js.ERRORMSG, jl.ETL_PROCEDURE
  FROM [DW_ETL_LOG].[JOB_DETAILS_LOG] AS js
  INNER JOIN [DW_ETL_LOG].[JOB_STATUS_LOG] AS jl
  ON js.JOB_LOG_ID = jl.JOB_LOG_ID
) AS JobData
GROUP BY
  ETL_PROCEDURE;

-- Count of transactions that has error
SELECT
  jl.ETL_PROCEDURE,
  COUNT(DISTINCT CASE WHEN js.ERRORMSG IS NULL THEN jl.ID ELSE NULL END) AS log_no_error_count,
  COUNT(DISTINCT CASE WHEN js.ERRORMSG IS NOT NULL THEN jl.ID ELSE NULL END) AS log_has_error_count
FROM
  [DW_ETL_LOG].[JOB_STATUS_LOG] AS jl
LEFT JOIN [DW_ETL_LOG].[JOB_DETAILS_LOG] AS js
  ON jl.JOB_LOG_ID = js.JOB_LOG_ID
GROUP BY
  jl.ETL_PROCEDURE;

-- -- Transactions that have error happened more than once
-- -- group by transaction name
-- SELECT jl.ETL_PROCEDURE, count(*) AS transactions
-- FROM (
--   SELECT 
--     JOB_LOG_ID, COUNT(*) AS ErrorCount
--   FROM JOB_DETAILS_LOG
--   WHERE ERRORMSG IS NOT NULL
--   GROUP BY JOB_LOG_ID
--   -- HAVING COUNT(*) >= 1
-- ) AS e
-- INNER JOIN JOB_STATUS_LOG as jl
-- ON e.JOB_LOG_ID = jl.ID
-- GROUP BY jl.ETL_PROCEDURE
--
