# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../../lib/garner/utils/persistence'

class DBProviderTest < Minitest::Test
  attr_reader :provider, :persistence, :db

  def setup(key: nil)
    Garner::Utils::Persistence.setup
    @provider = Garner::Utils::Persistence::Provider.new(key:)
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
