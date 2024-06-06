# frozen_string_literal: true

require_relative '../../../spec/helpers/test_helper'
require_relative '../../../lib/app/utils/persistence'

class DBProviderTest < Minitest::Test
  attr_reader :provider, :db

  def setup(key: nil)
    @provider = Garner::Utils::Persistence::Provider.new(key)
    @db = provider.rom
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
    assert provider.check, 'DB Schema should be valid'
  end
end
