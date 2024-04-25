# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :Job_Status_Log, schema: :DW_ETL_LOG do
      primary_key :JobLogId, type: :Bignum
      column :ETL_Procedure, String, size: 255, null: false
      column :ETL_Parameter, String, size: 512, null: true
      column :ETL_StartTime, 'datetime2', null: false
      column :ETL_CompleteTime, 'datetime2', null: true
      column :ETL_Status, Integer, null: true
      column :ETL_Status_Description, String, text: true, null: true
      column :ETL_Execute_by, String, size: 255, null: true
      column :ETL_Batch_ID, String, size: 100, null: true
      column :Records_Insert_DateTime, 'datetime2', null: true
      column :Logs_Collected, TrueClass, null: false, default: false

      index :ETL_CompleteTime
    end
  end
end
