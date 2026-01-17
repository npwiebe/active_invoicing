# frozen_string_literal: true

require "dotenv/load"
require_relative "active_invoicing/version"
require_relative "active_invoicing/accounting"
require_relative "active_invoicing/active_record"
require_relative "active_invoicing/configure"
require_relative "active_invoicing/errors"
require_relative "active_invoicing/railtie" if defined?(Rails)
require "shale"

module ActiveInvoicing
end
