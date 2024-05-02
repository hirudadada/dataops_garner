IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'dw')
BEGIN
    CREATE LOGIN [dw] WITH PASSWORD = '$(UserPassword)';
END

USE [$(DatabaseName)];

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'dw')
BEGIN
    CREATE USER [dw] FOR LOGIN [dw];
    ALTER ROLE db_ddladmin ADD MEMBER [dw];
    GRANT SELECT, INSERT, UPDATE ON SCHEMA::dbo TO dw;
    GRANT CREATE TABLE TO [dw];
    GRANT ALTER ON SCHEMA::dbo TO [dw];
    GRANT ALTER ON SCHEMA::DW_ETL_LOG TO [dw];
    GRANT CONTROL ON SCHEMA::dbo TO dw;
    GRANT CONTROL ON SCHEMA::DW_ETL_LOG TO dw;
END
