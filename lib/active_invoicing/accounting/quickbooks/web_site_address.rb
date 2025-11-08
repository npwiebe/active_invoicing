# frozen_string_literal: true

require "shale"

module ActiveInvoicing
  module Accounting
    module Quickbooks
      class WebSiteAddress < Shale::Mapper
        attribute :uri, Shale::Type::String

        json do
          map "URI", to: :uri
        end
      end
    end
  end
end
