# frozen_string_literal: true

require "spec_helper"

RSpec.describe(ActiveAccountingIntegration::UnimplementedMethodError) do
  describe "error class hierarchy" do
    it "inherits from StandardError" do
      expect(described_class.superclass).to(eq(StandardError))
    end
  end

  describe "error instantiation" do
    it "formats message with method name" do
      error = described_class.new("some_method")
      expect(error.message).to(eq("Method some_method is not implemented in ActiveAccountingIntegration::UnimplementedMethodError"))
    end

    it "can be raised and caught" do
      expect { raise described_class, "test_method" }
        .to(raise_error(described_class, "Method test_method is not implemented in ActiveAccountingIntegration::UnimplementedMethodError"))
    end
  end
end
