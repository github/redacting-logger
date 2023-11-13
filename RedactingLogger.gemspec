# frozen_string_literal: true

require_relative "lib/version"

Gem::Specification.new do |spec|
  spec.name          = "RedactingLogger"
  spec.version       = RedactingLogger::Version::VERSION
  spec.authors       = ["Grant Birkinbine"]
  spec.email         = "grant.birkinbine@gmail.com"
  spec.license       = "MIT"

  spec.summary       = "A redacting Ruby logger to prevent the leaking of secrets via logs"
  spec.description   = <<~SPEC_DESC
    A redacting Ruby logger to prevent the leaking of secrets via logs
  SPEC_DESC

  spec.homepage = "https://github.com/grantbirki/RedactingLogger"
  spec.metadata = {
    "source_code_uri" => "https://github.com/grantbirki/RedactingLogger",
    "documentation_uri" => "https://github.com/grantbirki/RedactingLogger",
    "bug_tracker_uri" => "https://github.com/grantbirki/RedactingLogger/issues"
  }

  spec.add_dependency "logger", "~> 1.6"

  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.files = %w[LICENSE README.md RedactingLogger.gemspec]
  spec.files += Dir.glob("lib/**/*.rb")
  spec.require_paths = ["lib"]
end
