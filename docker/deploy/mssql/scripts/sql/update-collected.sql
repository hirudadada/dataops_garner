UPDATE JOB_STATUS_LOGS
SET LOG_COLLECTED = GETDATE()
WHERE LOG_COLLECTED IS NOT NULL;
--
-- UPDATE JOB_LOGS
-- SET NAME = 'test-job-10'
-- WHERE NAME = 'test-job-7';
--
-- UPDATE JOB_LOGS
-- SET NAME = 'test-job-11'
-- WHERE NAME = 'test-job-8';
--
-- UPDATE JOB_LOGS
-- SET NAME = 'test-job-12'
-- WHERE NAME = 'test-job-9';
