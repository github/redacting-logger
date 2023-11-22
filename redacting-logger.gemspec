# frozen_string_literal: true

require_relative "lib/version"

Gem::Specification.new do |spec|
  spec.name          = "redacting-logger"
  spec.version       = RedactingLogger::Version::VERSION
  spec.authors       = ["GitHub", "GitHub Security"]
  spec.email         = "opensource@github.com"
  spec.license       = "MIT"

  spec.summary       = "A redacting Ruby logger to prevent the leaking of secrets via logs"
  spec.description   = <<~SPEC_DESC
    A redacting Ruby logger to prevent the leaking of secrets via logs
  SPEC_DESC

  spec.homepage = "https://github.com/github/redacting-logger"
  spec.metadata = {
    "source_code_uri" => "https://github.com/github/redacting-logger",
    "documentation_uri" => "https://github.com/github/redacting-logger",
    "bug_tracker_uri" => "https://github.com/github/redacting-logger/issues"
  }

  spec.add_dependency "logger", "~> 1.6"

  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.files = %w[LICENSE README.md redacting-logger.gemspec]
  spec.files += Dir.glob("lib/**/*.rb")
  spec.require_paths = ["lib"]
end
