# frozen_string_literal: true

require "logger"
require_relative "patterns/default"

# RedactingLogger is a custom logger that extends the standard Logger class.
# It redacts specified patterns in the log messages.
class RedactingLogger < Logger
  # Initializes a new instance of the RedactingLogger class.
  #
  # @param logdev [Object] The log device. Defaults to $stdout.
  # @param shift_age [Integer] The number of old log files to keep.
  # @param shift_size [Integer] The maximum logfile size.
  # @param redact_patterns [Array<String>] The patterns to redact from the log messages. Defaults to [].
  # @param redacted_msg [String] The message to replace the redacted patterns with.
  # @param use_default_patterns [Boolean] Whether to use the default patterns or not.
  # @param kwargs [Hash] Additional options to pass to the Logger class.
  #
  # logdev, shift_age, and shift_size are all using the defaults from the standard Logger class. -> https://github.com/ruby/logger/blob/0996f90650fd95718f0ffe835b965de18654b71c/lib/logger.rb#L578-L580
  def initialize(
    logdev = $stdout,
    shift_age = 0,
    shift_size = 1048576,
    redact_patterns: [],
    redacted_msg: "[REDACTED]",
    use_default_patterns: true,
    **kwargs
  )
    super(logdev, **kwargs)
    @redact_patterns = redact_patterns
    @redacted_msg = redacted_msg
    @redact_patterns += Patterns::DEFAULT if use_default_patterns
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
