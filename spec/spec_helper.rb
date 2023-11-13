# frozen_string_literal: true

# ENV["APP_ENV"] = "test"

require "simplecov"
require "rspec"
require "simplecov-erb"

COV_DIR = File.expand_path("../coverage", File.dirname(__FILE__))

SimpleCov.root File.expand_path("..", File.dirname(__FILE__))
SimpleCov.coverage_dir COV_DIR

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::ERBFormatter
]

SimpleCov.minimum_coverage 100

SimpleCov.at_exit do
  File.write("#{COV_DIR}/total-coverage.txt", SimpleCov.result.covered_percent)
  SimpleCov.result.format!
end

SimpleCov.start do
  add_filter "spec/"
  add_filter "vendor/gems/"
end
