#!/bin/bash
set -e

# Start SQL Server and send it into the background
/opt/mssql/bin/sqlservr &

MSSQL_PID=$!

until /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -Q "SELECT 1" &>/dev/null
do
    echo "Waiting for MSSQL to be up..."
    sleep 1
done

echo "SQL Server is up and running"

# Check if the database exists, and create it if it does not
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -d master -Q "IF DB_ID('${MSSQL_DATABASE}') IS NULL BEGIN PRINT 'Creating database ${MSSQL_DATABASE}'; CREATE DATABASE [${MSSQL_DATABASE}]; END"

/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -d master -v UserPassword="${MSSQL_SA_PASSWORD}" DatabaseName="${MSSQL_DATABASE}" -i ./sql/init.sql

# Wait for SQL Server process to terminate
wait $MSSQL_PID
