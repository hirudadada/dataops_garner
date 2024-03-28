#!/bin/bash

# Check if an argument was provided

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input_file.sql>"
  exit 1
fi

INPUT_FILE="$1"

/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -d "$MSSQL_DATABASE" -i "$INPUT_FILE"
