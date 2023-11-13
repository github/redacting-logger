# frozen_string_literal: true

require "logger"

class RedactingLogger < Logger
  def initialize(redact_patterns, *args)
    super(*args)
    @redact_patterns = redact_patterns
  end

  def add(severity, message = nil, progname = nil)
    if message
      @redact_patterns.each do |pattern|
        message = message.to_s.gsub(pattern, '[REDACTED]')
      end
    end

    if progname
      @redact_patterns.each do |pattern|
        progname = progname.to_s.gsub(pattern, '[REDACTED]')
      end
    end

    super(severity, message, progname)
  end
end
