#!/bin/bash

# Start SQL Server and send it into the background
/opt/mssql/bin/sqlservr &

# Capture the process ID of SQL Server so we can wait for it later
MSSQL_PID=$!

until /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -Q "SELECT 1" &>/dev/null
do
    echo "Waiting for MSSQL to be up..."
    sleep 1
done

/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -d master -Q "IF DB_ID('${MSSQL_DATABASE}') IS NULL BEGIN PRINT 'Creating database ${MSSQL_DATABASE}'; CREATE DATABASE [${MSSQL_DATABASE}]; END"

wait $MSSQL_PID
