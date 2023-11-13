# RedactingLogger

A redacting Ruby logger to prevent the leaking of secrets via logs

## Installation 💎

You can download this Gem from either [RubyGems](https://rubygems.org/gems/RedactingLogger) or [GitHub Packages](https://github.com/GrantBirki/RedactingLogger/pkgs/rubygems/RedactingLogger)

RubyGems (Recommended):

```bash
gem install RedactingLogger
```

> RubyGems [link](https://rubygems.org/gems/RedactingLogger)

Via a Gemfile:

```ruby
# frozen_string_literal: true

source "https://rubygems.org"

gem "RedactingLogger", "~> X.X.X" # Replace X.X.X with the latest version
```

## Usage 💻

```ruby
require "RedactingLogger"

logger = RedactingLogger.new([/REDACTED_PATTERN1/, /REDACTED_PATTERN2/], STDOUT)
logger.info("This is a message with a REDACTED_PATTERN1 and REDACTED_PATTERN2 in it.")
```

This will output:

```text
I, [timestamp]  INFO -- : This is a message with a [REDACTED] and [REDACTED] in it.
```
