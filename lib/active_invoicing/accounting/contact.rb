# frozen_string_literal: true

require "active_model"

module ActiveInvoicing
  module Accounting
    class Contact
      include ActiveModel::Model

      # attribute
      attr_accessor :name, :email, :phone, :address, :city, :state, :zip, :country

      # associations
      attr_accessor :invoices

      class << self
        def find_by_id(id, connection)
          raise NotImplementedError, "This method should be implemented in a subclass"
        end
      end
    end
  end
end
