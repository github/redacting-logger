# frozen_string_literal: true

# This module contains the default patterns to redact.
module Patterns
  DEFAULT = [
    /ghp_[a-zA-Z0-9]{36,}/, # GitHub Personal Access Token
    /github_pat_[a-zA-Z0-9]{22}_[a-zA-Z0-9]{59}/, # GitHub Personal Access Token (fine-grained)
    /ghs_[a-zA-Z0-9]{36}/ # Temporary GitHub Actions Tokens
  ].freeze
end
