# frozen_string_literal: true

module ActiveAccountingIntegration
  class UnimplementedMethodError < StandardError
    def initialize(method_name)
      super("Method #{method_name} is not implemented in #{self.class.name}")
    end
  end
end
