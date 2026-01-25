# frozen_string_literal: true

require "dotenv/load"
require_relative "active_accounting_integration/version"
require_relative "active_accounting_integration/accounting"
require_relative "active_accounting_integration/active_record"
require_relative "active_accounting_integration/configure"
require_relative "active_accounting_integration/errors"
require_relative "active_accounting_integration/railtie" if defined?(Rails)
require "shale"

module ActiveAccountingIntegration
end
