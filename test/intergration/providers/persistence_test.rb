# frozen_string_literal: true

require_relative '../../../test/helpers/test_helper'

class DBProviderTest < Minitest::Test
  attr_reader :db, :validator

  def setup
    Garner::Utils::Persistence.start_service
    provider = Garner::Utils::Persistence::Provider.new
    @db = provider.rom
    @validator = Garner::Utils::Persistence::Validator.new
  end

  def test_db_provider_registered
    assert db, 'DB provider should be registered'
  end

  def test_db_container_valid
    assert_instance_of ROM::Container, db, 'DB should be an instance of ROM::Container'
  end

  def test_db_connection_valid
    gateway = db.gateways[:default]
    assert gateway.connection, 'DB connection should be valid'
  end

  def test_db_schema_valid
    assert validator.validate, 'DB Schema should be valid'
  end
end
