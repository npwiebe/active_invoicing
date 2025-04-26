# frozen_string_literal: true

require File.expand_path("lib/active_invoicing/version", __dir__)

Gem::Specification.new do |spec|
  spec.name = "active_invoicing"
  spec.version = ActiveInvoicing::VERSION
  spec.authors = ["Noah Wiebe"]
  spec.email = ["npwiebe@gmaill.com"]
  spec.summary = "A Ruby gem for managing invoicing and accounting tasks."
  spec.description = "ActiveInvoicing is a Ruby gem that provides a simple and efficient way to manage invoicing and accounting tasks, integrating with popular accounting platforms."
  spec.license = "MIT"
  spec.platform = Gem::Platform::RUBY
  spec.files = Dir["lib/**/*.rake", "lib/**/*.rb", "README.md", "LICENSE.txt"]

  spec.add_dependency("activemodel")
  spec.add_dependency("activesupport")
  spec.add_dependency("faraday")
  spec.add_dependency("oauth2")

  spec.add_development_dependency("dotenv")
end
