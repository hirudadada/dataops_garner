# frozen_string_literal: true

module Inventory
  module Operations < Inventory::Operation
    class DatetimeTransformations
      def self.datetime_to_iso8601(value)
        value.utc.iso8601
      end

      def self.iso8601_to_datetime(value)
        ::DateTime.parse(value)
      end

      def self.time_to_iso8601(value)
        value.utc.iso8601
      end

      def self.iso8601_to_time(value)
        ::Time.parse(value).utc
      end

      def self.time_to_datetime(value)
        value.to_datetime
      end

      def self.datetime_to_time(value)
        value.to_time
      end
    end
  end
end
