SELECT SCHEMA_NAME(schema_id) AS SchemaName, name AS TableName
FROM sys.tables
WHERE name = 'JOB_STATUS_LOG' OR name = 'JOB_DETAILS_LOG'
