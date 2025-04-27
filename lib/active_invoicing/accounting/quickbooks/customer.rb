# frozen_string_literal: true

require "json"

module ActiveInvoicing
  module Accounting
    module Quickbooks
      class Customer < ActiveInvoicing::Accounting::Contact
        class << self
          def find_by_id(id, connection)
            return unless id && connection && connection.is_a?(ActiveInvoicing::Accounting::Quickbooks::Connection)

            response = connection.make_request(:get, "/v3/company/#{connection.realm_id}/customer/#{id}")
            customer_data = JSON.parse(response.body)
            customer = customer_data["Customer"]
            return unless customer

            build_customer(customer)
          end

          def find_all(connection)
            return unless connection && connection.is_a?(ActiveInvoicing::Accounting::Quickbooks::Connection)

            response = connection.make_request(:get, "/v3/company/#{connection.realm_id}/query?query=select * from Customer")
            customers_data = JSON.parse(response.body)
            return unless customers_data

            customers_data["QueryResponse"]["Customer"].map do |customer|
              build_customer(customer)
            end
          end

          private

          def build_customer(data)
            new(
              id: data["Id"],
              name: data["DisplayName"],
              email: data["PrimaryEmailAddr"]&.dig("Address"),
              phone: data["PrimaryPhone"]&.dig("FreeFormNumber"),
            )
          end
        end
      end
    end
  end
end
