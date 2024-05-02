# frozen_string_literal: true

Sequel.migration do
  up do
    run 'CREATE SCHEMA DW_ETL_LOG'
  end

  down do
    run 'DROP SCHEMA DW_ETL_LOG'
  end
end
