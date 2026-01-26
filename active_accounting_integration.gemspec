# frozen_string_literal: true

require File.expand_path("lib/active_accounting_integration/version", __dir__)

Gem::Specification.new do |spec|
  spec.name = "active_accounting_integration"
  spec.version = ActiveAccountingIntegration::VERSION
  spec.authors = ["Noah Wiebe"]
  spec.email = ["npwiebe@gmail.com"]
  spec.summary = "A Ruby gem for managing invoicing and accounting tasks."
  spec.description = "ActiveAccountingIntegration is a Ruby gem that provides a simple and efficient way to manage invoicing and accounting tasks, integrating with popular accounting platforms."
  spec.license = "MIT"
  spec.platform = Gem::Platform::RUBY
  spec.files = Dir["lib/**/*.rake", "lib/**/*.rb", "README.md", "LICENSE.txt"]

  spec.add_dependency("activemodel")
  spec.add_dependency("activesupport")
  spec.add_dependency("faraday")
  spec.add_dependency("oauth2")
  spec.add_dependency("shale")

  spec.add_development_dependency("dotenv")
  spec.add_development_dependency("irb")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("rspec")
end
