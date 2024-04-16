# frozen_string_literal: true

module Garner
  module Persistence
    DbSchema = Dry::Schema.Params do
      required(:name).filled(:string)
      required(:db_user).filled(:string)
      required(:db_password).filled(:string)
      required(:database_url).filled(:string)
      required(:enable_sql_log).filled(:bool)
    end
  end
end
