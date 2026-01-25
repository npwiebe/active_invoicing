# frozen_string_literal: true

require "spec_helper"

RSpec.describe(ActiveAccountingIntegration::Accounting) do
  describe "autoloading" do
    it "loads all accounting files" do
      expect(defined?(ActiveAccountingIntegration::Accounting::Connection)).to(be_truthy)
      expect(defined?(ActiveAccountingIntegration::Accounting::Quickbooks::Connection)).to(be_truthy)
      expect(defined?(ActiveAccountingIntegration::Accounting::Quickbooks::Customer)).to(be_truthy)
      expect(defined?(ActiveAccountingIntegration::Accounting::Quickbooks::Invoice)).to(be_truthy)
    end

    it "loads files in sorted order" do
      accounting_dir = File.join(__dir__, "../../../lib/active_accounting_integration/accounting")
      files = Dir[File.join(accounting_dir, "**", "*.rb")].sort

      expect(files).to(include(
        a_string_ending_with("accounting/connection.rb"),
        a_string_ending_with("accounting/quickbooks/connection.rb"),
        a_string_ending_with("accounting/quickbooks/customer.rb"),
        a_string_ending_with("accounting/quickbooks/invoice.rb"),
      ))
    end
  end

  describe "module structure" do
    it "is a module" do
      expect(ActiveAccountingIntegration::Accounting).to(be_a(Module))
    end

    it "is nested under ActiveAccountingIntegration" do
      expect(ActiveAccountingIntegration::Accounting.name).to(eq("ActiveAccountingIntegration::Accounting"))
    end
  end
end
