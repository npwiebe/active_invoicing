# frozen_string_literal: true

module ActiveInvoicing
  module Accounting
    class Connection
      INTEGRATIONS = {
        quickbooks: "ActiveInvoicing::Accounting::Quickbooks::Connection",
      }

      class << self
        def new_connection(integration, *options)
          integration_class = INTEGRATIONS[integration.to_sym]
          if integration_class
            Object.const_get(integration_class).new(*options)
          else
            raise ArgumentError, "Unsupported integration: #{integration}"
          end
        end
      end
    end
  end
end
