# frozen_string_literal: true

require "logger"

# RedactingLogger is a custom logger that extends the standard Logger class.
# It redacts specified patterns in the log messages.
class RedactingLogger < Logger
  # Initializes a new instance of the RedactingLogger class.
  #
  # @param redact_patterns [Array<String>] The patterns to redact from the log messages. Defaults to [].
  # @param log_device [Object] The log device (file, STDOUT, etc.) to write to. Defaults to STDOUT.
  # @param redacted_msg [String] The message to replace the redacted patterns with.
  # @param use_default_patterns [Boolean] Whether to use the default patterns or not.
  # @param kwargs [Hash] Additional options to pass to the Logger class.
  def initialize(
    redact_patterns: [],
    log_device: $stdout,
    redacted_msg: "[REDACTED]",
    use_default_patterns: true,
    **kwargs
  )
    super(log_device, **kwargs)
    @redact_patterns = redact_patterns
    @redacted_msg = redacted_msg
    add_default_patterns if use_default_patterns
  end

  # Helper method for adding built-in patterns to the redact_patterns array.
  #
  # @return [Array<String>] The updated redact_patterns array.
  def add_default_patterns
    @redact_patterns += [
      /^ghp_[a-zA-Z0-9]{36}$/, # GitHub Personal Access Token
      /^github_pat_[a-zA-Z0-9]{22}_[a-zA-Z0-9]{59}$/ # GitHub Personal Access Token (fine-grained)
    ]
  end

  # Adds a message to the log.
  #
  # @param severity [Integer] The severity level of the message.
  # @param message [String] The message to log.
  # @param progname [String] The name of the program.
  def add(severity, message = nil, progname = nil)
    message, progname = yield if block_given?

    if message
      @redact_patterns.each do |pattern|
        message = message.to_s.gsub(pattern, "[REDACTED]")
      end
    end

    if progname
      @redact_patterns.each do |pattern|
        progname = progname.to_s.gsub(pattern, "[REDACTED]")
      end
    end

    super(severity, message, progname)
  end
end
