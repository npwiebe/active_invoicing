# frozen_string_literal: true

module ActiveInvoicing
  module Accounting
    module Quickbooks
      class Customer < ActiveInvoicing::Accounting::Contact
        def to_hash
          {
            id: customer.id,
            name: customer.display_name,
            email: customer.primary_email_address,
            phone: customer.primary_phone,
            address: format_address(customer.bill_addr),
            billing_address: format_address(customer.bill_addr),
            shipping_address: format_address(customer.ship_addr),
          }
        end

        class << self
          def find_by_id(id, connection)
            return unless id && connection && connection.is_a?(ActiveInvoicing::Accounting::Quickbooks::Connection)

            connection.make_request(:get, "/v3/company/#{connection.realm_id}/customer/#{id}") do |response|
              customer_data = response.body
            end

            return unless customer_data

            new(customer_data)
          end
        end
      end
    end
  end
end
