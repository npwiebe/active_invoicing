# frozen_string_literal: true

require "shale"

module ActiveInvoicing
  module Accounting
    module Quickbooks
      class EmailAddress < Shale::Mapper
        attribute :address, Shale::Type::String

        json do
          map "Address", to: :address
        end
      end
    end
  end
end
