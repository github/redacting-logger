# redacting-logger

[![test](https://github.com/github/redacting-logger/actions/workflows/test.yml/badge.svg)](https://github.com/github/redacting-logger/actions/workflows/test.yml) [![lint](https://github.com/github/redacting-logger/actions/workflows/lint.yml/badge.svg)](https://github.com/github/redacting-logger/actions/workflows/lint.yml) [![build](https://github.com/github/redacting-logger/actions/workflows/build.yml/badge.svg)](https://github.com/github/redacting-logger/actions/workflows/build.yml) [![CodeQL](https://github.com/github/redacting-logger/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/github/redacting-logger/actions/workflows/codeql-analysis.yml) [![release](https://github.com/github/redacting-logger/actions/workflows/release.yml/badge.svg)](https://github.com/github/redacting-logger/actions/workflows/release.yml)

A redacting Ruby logger to prevent the leaking of secrets via logs

> This Gem wraps the official Ruby [`logger`](https://github.com/ruby/logger) utility

![Gem](docs/assets/gem.png)

## Installation 💎

You can download this Gem from [GitHub Packages](https://github.com/github/redacting-logger/pkgs/rubygems/redacting-logger) or [RubyGems](https://rubygems.org/gems/redacting-logger)

Via a Gemfile:

```ruby
source "https://rubygems.org"

gem "redacting-logger", "~> X.X.X" # Replace X.X.X with the latest version
```

## Usage 💻

### Basic

```ruby
require "redacting_logger"

# Create a new logger
logger = RedactingLogger.new(redact_patterns: [/topsecret/])

# Log a message that contains some redacted pattern
logger.info("This is a topsecret message.")
```

This will output:

```text
I, [timestamp]  INFO -- : This is a [REDACTED] message.
```

### Advanced

```ruby
require "redacting_logger"

# Create a new logger
logger = RedactingLogger.new(
  $stdout, # The device to log to (defaults to $stdout if not provided)
  redact_patterns: [/REDACTED_PATTERN1/, /REDACTED_PATTERN2/], # An array of Regexp patterns to redact from the logs
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

## Default Redaction Patterns

This Gem comes pre-built with a few redaction patterns to help you get started. These patterns can be located in [`lib/patterns/default.rb`](lib/patterns/default.rb)

A few examples of these patterns are:

- GitHub Personal Access Tokens
- GitHub Temporary Actions Tokens
- RSA Private Keys
- JWT Tokens

You can disable these default patterns with:

```ruby
logger = RedactingLogger.new(
  use_default_patterns: false # Whether to use the default built-in patterns or not
)
```
