# frozen_string_literal: true

# This module contains the default patterns to redact.
module Patterns
  DEFAULT = [
    /ghp_[A-Za-z0-9]{36,}|[0-9A-Fa-f]{40,}/, # GitHub Personal Access Token
    /github_pat_[a-zA-Z0-9]{22}_[a-zA-Z0-9]{59}/, # GitHub Personal Access Token (fine-grained)
    /ghs_[a-zA-Z0-9]{36}/, # Temporary GitHub Actions Tokens
    %r{\b(ey[a-zA-Z0-9]{17,}\.ey[a-zA-Z0-9/\\_-]{17,}\.(?:[a-zA-Z0-9/\\_-]{10,}={0,2})?)(?:['|"|\n|\r|\s|\x60|;]|$)}, # JWT tokens
    /(?i)-----BEGIN[ A-Z0-9_-]{0,100}PRIVATE KEY( BLOCK)?-----[\s\S-]*KEY( BLOCK)?----/, # private keys
    %r{https://hooks\.slack\.com/services/[a-zA-Z0-9]{9,}/[a-zA-Z0-9]{9,}/[a-zA-Z0-9]{24}}, # Slack webhook
    /xoxp-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9a-f]{6,})|xoxb-(?:[0-9]{7,})-(?:[A-Za-z0-9]{14,})|xoxs-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9a-f]{7,})|xoxa-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9a-f]{7,})|xoxo-(?:[0-9]{7,})-(?:[A-Za-z0-9]{14,})|xoxa-2-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9a-f]{7,})|xoxr-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9a-f]{7,})|xoxb-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[A-Za-z0-9]{14,})/, # Slack tokens
    /[sb]\.[a-zA-Z0-9]{24,}/ # vault token
  ].freeze
end
