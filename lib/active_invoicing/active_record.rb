# frozen_string_literal: true

module ActiveInvoicing
  Dir[File.join(__dir__, "active_record", "**", "*.rb")].sort.each { |file| require file }
end
