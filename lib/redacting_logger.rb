require "logger"

# RedactingLogger is a custom logger that extends the standard Logger class.
# It redacts specified patterns in the log messages.
class RedactingLogger < Logger
  # Initializes a new instance of the RedactingLogger class.
  #
  # @param redact_patterns [Array<String>] The patterns to redact from the log messages. Defaults to [].
  # @param log_device [Object] The log device (file, STDOUT, etc.) to write to. Defaults to STDOUT.
  # @param redacted_msg [String] The message to replace the redacted patterns with.
  # @param kwargs [Hash] Additional options to pass to the Logger class.
  def initialize(redact_patterns: [], log_device: STDOUT, redacted_msg: "[REDACTED]", **kwargs)
    super(log_device, **kwargs)
    @redact_patterns = redact_patterns
    @redacted_msg = redacted_msg
  end

  # Adds a message to the log.
  #
  # @param severity [Integer] The severity level of the message.
  # @param message [String] The message to log.
  # @param progname [String] The name of the program.
  def add(severity, message = nil, progname = nil)
    if message
      @redact_patterns.each do |pattern|
        message = message.to_s.gsub(pattern, @redacted_msg)
      end
    end

    if progname
      @redact_patterns.each do |pattern|
        progname = progname.to_s.gsub(pattern, @redacted_msg)
      end
    end

    super(severity, message, progname)
  end
end
