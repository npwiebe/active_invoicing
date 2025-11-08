# frozen_string_literal: true

module FixtureHelper
  def load_fixture(fixture_name)
    fixture_path = File.join(File.dirname(__FILE__), "../../fixtures", "#{fixture_name}.json")
    JSON.parse(File.read(fixture_path))
  end

  def load_quickbooks_fixture(fixture_name)
    fixture_path = File.join(File.dirname(__FILE__), "../../fixtures/quickbooks", "#{fixture_name}.json")
    File.read(fixture_path)
  end
end

RSpec.configure do |config|
  config.include(FixtureHelper)
end
