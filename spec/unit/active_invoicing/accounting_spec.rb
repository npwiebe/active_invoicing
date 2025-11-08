# frozen_string_literal: true

require "spec_helper"

RSpec.describe(ActiveInvoicing::Accounting) do
  describe "autoloading" do
    it "loads all accounting files" do
      expect(defined?(ActiveInvoicing::Accounting::Connection)).to(be_truthy)
      expect(defined?(ActiveInvoicing::Accounting::Quickbooks::Connection)).to(be_truthy)
      expect(defined?(ActiveInvoicing::Accounting::Quickbooks::Customer)).to(be_truthy)
      expect(defined?(ActiveInvoicing::Accounting::Quickbooks::Invoice)).to(be_truthy)
    end

    it "loads files in sorted order" do
      accounting_dir = File.join(__dir__, "../../../lib/active_invoicing/accounting")
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
      expect(ActiveInvoicing::Accounting).to(be_a(Module))
    end

    it "is nested under ActiveInvoicing" do
      expect(ActiveInvoicing::Accounting.name).to(eq("ActiveInvoicing::Accounting"))
    end
  end
end
