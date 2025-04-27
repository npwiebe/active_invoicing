# frozen_string_literal: true

require "singleton"

module ActiveInvoicing
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      Configuration.instance
    end
    alias_method :config, :configuration
  end

  class Configuration
    include Singleton

    cattr_accessor :quickbooks_client_id, :quickbooks_client_secret, :sandbox_mode
  end
end

ActiveInvoicing.configure do |config|
  config.quickbooks_client_id = ENV["QUICKBOOKS_CLIENT_ID"]
  config.quickbooks_client_secret = ENV["QUICKBOOKS_CLIENT_SECRET"]
  config.sandbox_mode = ENV["SANDBOX_MODE"] == "true"
end
