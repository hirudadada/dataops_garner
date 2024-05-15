# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table Sequel[:DW_ETL_LOG][:Job_Status_Log] do
      drop_column :Logs_Collected
      add_column :Logs_Collected, 'datetime2', null: true
    end
  end

  down do
    alter_table Sequel[:DW_ETL_LOG][:Job_Status_Log] do
      drop_column :Logs_Collected
      add_column :Logs_Collected, 'bit', null: false, default: false
    end
  end
end
