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
    let(:logger) { RedactingLogger.new(logdev, redact_patterns: [/secret/, /password/, /token_[A-Z]{5}/, /999999999/]) }

    [
      {
        case: "secret message",
        message: "This is a secret password",
        expected_message: "This is a [REDACTED] [REDACTED]"
      },
      {
        case: "secret progname",
        progname: "secret progname",
        expected_progname: "[REDACTED] progname"
      },
      {
        case: "secret substring",
        message: "This is a supersecretmessage",
        expected_message: "This is a super[REDACTED]message"
      },
      {
        case: "github token",
        message: "token ghp_aBcdeFghIjklMnoPqRSTUvwXYZ1234567890",
        expected_message: "token [REDACTED]"
      },
      {
        case: "github token hidden in another string",
        message: "token ghp_aBcdeFghIjklMnoPqRSTUvwXYZ1234567890ohnothisisnotgood",
        expected_message: "token [REDACTED]"
      },
      {
        case: "fine-grained github pat",
        message: "token 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",
        expected_message: "token [REDACTED]"
      },
      {
        case: "github action pat",
        message: "token ghs_1234567890abcdefghijklmnopqrstuvwxyz123456",
        expected_message: "token [REDACTED]123456"
      },
      {
        case: "custom token",
        message: "token token_ABCDE",
        expected_message: "token [REDACTED]"
      },
      {
        case: "custom token only if long enough",
        message: "token token_ABCD",
        expected_message: "token token_ABCD"
      },
      {
        case: "JWT token",
        message: "token eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
        expected_message: "token [REDACTED]"
      },
      {
        case: "RSA private key",
        message: "token #{File.read("spec/fixtures/fake.private_key")}",
        expected_message: "token [REDACTED]-\n"
      },
      {
        case: "list of messages",
        message: ["this", "is", "a", "secret"],
        expected_message: ["this", "is", "a", "[REDACTED]"]
      },
      {
        case: "hash of messages",
        message: { this: "is", "a" => "secret" },
        expected_message: { this: "is", "a" => "[REDACTED]" }
      },
      {
        case: "hash of messages more complex",
        message: { this: "is", "a" => "super top secret" },
        expected_message: { this: "is", "a" => "super top [REDACTED]" }
      },
      {
        case: "redacts from a symbol",
        message: :top_secret,
        expected_message: "top_[REDACTED]"
      },
      {
        case: "redacts from a Numeric full match",
        message: 999_999_999,
        expected_message: "[REDACTED]"
      },
      {
        case: "redacts from a Numeric match with extra numbers",
        message: 123_999_999_999_123,
        expected_message: "123[REDACTED]123"
      },
      {
        case: "redacts a Slack webhook",
        message: "posting slack message to: https://hooks.slack.com/services/T1BAAA111/B0111AAA111/MMMAAA333CCC222bbbAAA111",
        expected_message: "posting slack message to: [REDACTED]"
      },
      {
        case: "redacts a Slack token",
        message: "using slack token: xoxb-2444333222111-2444333222111-123456789AbCdEfGHi123456",
        expected_message: "using slack token: [REDACTED]"
      },
      {
        case: "redacts a vault token",
        message: "logging into vault with token: s.FakeToken1234567890123456",
        expected_message: "logging into vault with token: [REDACTED]"
      }
    ].each do |test|
      it "redacts #{test[:case]}" do
        expect_any_instance_of(Logger).to receive(:add).with(0, test[:expected_message], test[:expected_progname])
        logger.add(0, test[:message], test[:progname])
      end
    end

    it "redacts with given block" do
      logger.info { ["This is a secret password", nil] }

      logdev.rewind
      log_output = logdev.read

      expect(log_output).to match(/This is a \[REDACTED\] \[REDACTED\]/)
    end
  end
end
