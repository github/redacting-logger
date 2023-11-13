# frozen_string_literal: true
require "logger"
require "stringio"
require_relative "../spec_helper"
require_relative "../../lib/redacting_logger"

describe RedactingLogger do
  context "#initialize" do
    it "ensures the class is initialized properly" do
      redact_patterns = ["secret", "password"]
      level = Logger::INFO
      logger = RedactingLogger.new(
        redact_patterns:,
        log_device: $stdout,
        level:,
        redacted_msg: "!!!REDACTED!!!",
        use_default_patterns: false
      )

      expect(logger.level).to eq(level)
      expect(logger.instance_variable_get(:@redact_patterns)).to eq(redact_patterns)
      expect(logger.instance_variable_get(:@logdev).dev).to eq($stdout)
      expect(logger.instance_variable_get(:@redacted_msg)).to eq("!!!REDACTED!!!")
    end

    it "ensures the class is initialized properly with default values" do
      logger = RedactingLogger.new(use_default_patterns: false)
      expect(logger.level).to eq(Logger::DEBUG)
      expect(logger.instance_variable_get(:@redact_patterns)).to eq([])
      expect(logger.instance_variable_get(:@logdev).dev).to eq($stdout)
      expect(logger.instance_variable_get(:@redacted_msg)).to eq("[REDACTED]")
    end
  end

  context "#add" do
    let(:log_device) { StringIO.new }
    let(:logger) { RedactingLogger.new(redact_patterns: ["secret", "password"], log_device:) }

    it "ensures the message is redacted" do
      logger.info { ["This is a secret password", nil] }

      log_device.rewind
      log_output = log_device.read

      expect(log_output).to match(/This is a \[REDACTED\] \[REDACTED\]/)
    end

    it "ensures the progname is redacted" do
      logger.info { ["This is a message", "secret"] }

      log_device.rewind
      log_output = log_device.read

      expect(log_output).to match(/\[REDACTED\]: This is a message/)
    end

    it "redacts the message when it is a substring of the redact pattern" do
      logger.info("This is a supersecretmessage")

      log_device.rewind
      log_output = log_device.read
      expect(log_output).to match(/This is a super\[REDACTED\]message/)
    end
  end
end
