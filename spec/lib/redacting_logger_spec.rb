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
        $stdout,
        redact_patterns:,
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

    it "ensures the class is initialized properly with default values and uses built-in patterns" do
      logger = RedactingLogger.new($stdout, use_default_patterns: true)
      expect(logger.level).to eq(Logger::DEBUG)
      expect(logger.instance_variable_get(:@redact_patterns).length).to be > 0
      expect(logger.instance_variable_get(:@logdev).dev).to eq($stdout)
      expect(logger.instance_variable_get(:@redacted_msg)).to eq("[REDACTED]")
    end
  end

  context "#add" do
    let(:logdev) { StringIO.new }
    let(:logger) { RedactingLogger.new(logdev, redact_patterns: [/secret/, /password/, /token_[A-Z]{5}/]) }

    it "ensures the message is redacted" do
      logger.info { ["This is a secret password", nil] }

      logdev.rewind
      log_output = logdev.read

      expect(log_output).to match(/This is a \[REDACTED\] \[REDACTED\]/)
    end

    it "ensures the progname is redacted" do
      logger.info { ["This is a message", "secret"] }

      logdev.rewind
      log_output = logdev.read

      expect(log_output).to match(/\[REDACTED\]: This is a message/)
    end

    it "redacts the message when it is a substring of the redact pattern" do
      logger.info("This is a supersecretmessage")

      logdev.rewind
      log_output = logdev.read
      expect(log_output).to match(/This is a super\[REDACTED\]message/)
    end

    it "redacts a GitHub Personal Access Token that is 40 characters" do
      token = "ghp_aBcdeFghIjklMnoPqRSTUvwXYZ1234567890"

      logger.info("logging in with token #{token} ...")

      logdev.rewind
      log_output = logdev.read
      expect(log_output).to match(/logging in with token \[REDACTED\] .../)
    end

    it "redacts a GitHub Personal Access Token got mashed with another string" do
      token = "ghp_aBcdeFghIjklMnoPqRSTUvwXYZ1234567890ohnothisisnotgood"

      logger.info("logging in with token #{token} ...")

      logdev.rewind
      log_output = logdev.read
      expect(log_output).to match(/logging in with token \[REDACTED\] .../)
    end

    it "redacts a fine-grained GitHub Personal Access Token" do
      # This token is not real, but it is the correct length and format
      token = "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"

      logger.warn("oh no, I failed to login with that token: #{token}, try again")

      logdev.rewind
      log_output = logdev.read
      expect(log_output).to match(/oh no, I failed to login with that token: \[REDACTED\], try again/)
    end

    it "redacts a GitHub Actions temp token" do
      token = "ghs_1234567890abcdefghijklmnopqrstuvwxyz123456"

      logger.debug("GitHub Actions token: #{token}")

      logdev.rewind
      log_output = logdev.read
      expect(log_output).to match(/GitHub Actions token: \[REDACTED\]/)
    end

    it "redacts a custom token" do
      token = "token_ABCDE"

      logger.fatal("Custom token: #{token}")

      logdev.rewind
      log_output = logdev.read
      expect(log_output).to match(/Custom token: \[REDACTED\]/)
    end

    it "does not remove a token that is too short" do
      token = "token_ABCD"

      logger.fatal("Custom token: #{token}")

      logdev.rewind
      log_output = logdev.read

      expect(log_output).to match(/Custom token: token_ABCD/)
    end

    it "redacts a JWT token" do
      # this is a dummy JWT token, but it is the correct length and format
      token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

      logger.info("JWT token: #{token}")

      logdev.rewind
      log_output = logdev.read

      expect(log_output).to match(/JWT token: \[REDACTED\]/)
    end

    it "redacts a RSA private key" do
      fake_private_key = File.read("spec/fixtures/fake.private_key")

      logger.info("RSA private key: #{fake_private_key}")

      logdev.rewind
      log_output = logdev.read
      expect(log_output).to match(/RSA private key: \[REDACTED\]/)
    end
  end
end
