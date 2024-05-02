# frozen_string_literal: true

ROM::SQL.migration do
  up do
    create_table Sequel[:DW_ETL_LOG][:Job_Details_Log] do
      primary_key :StepId, type: :Bignum
      foreign_key :JobLogId, Sequel[:DW_ETL_LOG][:Job_Status_Log], type: :Bignum, on_delete: :cascade

      column :Step, String, size: 255, null: false
      column :Step_Status, String, size: 512, null: true
      column :EndTime, 'datetime2', null: false
      column :UpdatedRecordCount, Integer, null: true
      column :ErrorMsg, String, size: 255, null: true
      if ENV['DB_ADAPTER'] == 'tinytds'
        column :Remark, String, size: :max, null: true  # Use VARCHAR(MAX) for SQL Server
      else
        column :Remark, String, text: true, null: true  # Use TEXT for other databases
      end
    end
  end

  down do
    drop_table(Sequel[:DW_ETL_LOG][:Job_Details_Log])
  end
end

