# frozen_string_literal: true

module ActiveAccountingIntegration
  Dir[File.join(__dir__, "accounting", "**", "*.rb")].sort.each { |file| require file }
end
