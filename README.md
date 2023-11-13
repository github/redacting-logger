# redacting-logger

A redacting Ruby logger to prevent the leaking of secrets via logs

## Installation 💎

You can download this Gem from either [RubyGems](https://rubygems.org/gems/redacting-logger) or [GitHub Packages](https://github.com/GrantBirki/redacting-logger/pkgs/rubygems/redacting-logger)

RubyGems (Recommended):

```bash
gem install redacting-logger
```

> RubyGems [link](https://rubygems.org/gems/redacting-logger)

Via a Gemfile:

```ruby
# frozen_string_literal: true

source "https://rubygems.org"

gem "redacting-logger", "~> X.X.X" # Replace X.X.X with the latest version
```

## Usage 💻

```ruby
require "redacting_logger"

# Create a new logger
logger = RedactingLogger.new(
  redact_patterns: [/REDACTED_PATTERN1/, /REDACTED_PATTERN2/], # An array of Regexp patterns to redact from the logs
  log_device: $stdout, # The device to log to
  level: Logger::INFO, # The log level to use
  redacted_msg: "[REDACTED]", # The message to replace the redacted patterns with
  use_default_patterns: true # Whether to use the default built-in patterns or not
)

# Log a message that contains some redacted patterns
logger.info("This is a message with a REDACTED_PATTERN1 and REDACTED_PATTERN2 in it.")
```

This will output:

```text
I, [timestamp]  INFO -- : This is a message with a [REDACTED] and [REDACTED] in it.
```
