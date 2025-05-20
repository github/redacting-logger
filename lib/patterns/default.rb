# frozen_string_literal: true

# This module contains the default patterns to redact.
# These patterns are sourced from different places on the internet, some came from https://github.com/l4yton/RegHex
module Patterns
  DEFAULT = [
    # RubyGems Token
    # https://guides.rubygems.org/api-key-scopes/
    /rubygems_[0-9a-f]{48}/,

    # GitHub Personal Access Token
    # https://github.blog/2021-04-05-behind-githubs-new-authentication-token-formats/
    /ghp_[A-Za-z0-9]{36,}|[0-9A-Fa-f]{40,}/,
    /github_pat_[a-zA-Z0-9]{22}_[a-zA-Z0-9]{59}/, # Fine Grained
    /ghs_[a-zA-Z0-9]{36}/, # Temporary Actions Tokens

    # JWT Token
    # https://en.wikipedia.org/wiki/JSON_Web_Token
    %r{\b(ey[a-zA-Z0-9]{17,}\.ey[a-zA-Z0-9/\\_-]{17,}\.(?:[a-zA-Z0-9/\\_-]{10,}={0,2})?)(?:['|"|\n|\r|\s|\x60|;]|$)},

    # PEM Private Keys
    # https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail
    /(?i)-----BEGIN[ A-Z0-9_-]{0,100}PRIVATE KEY( BLOCK)?-----[\s\S-]*KEY( BLOCK)?----/,

    # Slack Webhook
    # https://api.slack.com/messaging/webhooks
    %r{https://hooks\.slack\.com/services/[a-zA-Z0-9]{9,}/[a-zA-Z0-9]{9,}/[a-zA-Z0-9]{24}},

    # Slack Workflows
    %r{https://hooks\.slack\.com/workflows/[a-zA-Z0-9]{9,}/[a-zA-Z0-9]{9,}/[0-9]+?/[a-zA-Z0-9]{24}},

    # Slack Trigger
    # https://slack.com/help/articles/360041352714-Build-a-workflow--Create-a-workflow-that-starts-outside-of-Slack
    %r{https://hooks\.slack\.com/triggers/.+},

    # Slack Tokens
    # https://api.slack.com/authentication/token-types
    /xoxp-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9a-f]{6,})/,
    /xoxb-(?:[0-9]{7,})-(?:[A-Za-z0-9]{14,})/,
    /xoxs-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9a-f]{7,})/,
    /xoxa-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9a-f]{7,})/,
    /xoxo-(?:[0-9]{7,})-(?:[A-Za-z0-9]{14,})/,
    /xoxa-2-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9a-f]{7,})/,
    /xoxr-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[0-9a-f]{7,})/,
    /xoxb-(?:[0-9]{7,})-(?:[0-9]{7,})-(?:[A-Za-z0-9]{14,})/,

    # Vault Tokens
    # https://github.com/hashicorp/vault/issues/27151
    /[sbr]\.[a-zA-Z0-9]{24,}/, # <= 1.9.x
    /hv[sbr]\.[a-zA-Z0-9]{24,}/, # >= 1.10

    # Authorization bearer tokens
    # https://datatracker.ietf.org/doc/html/rfc6750#section-2.1
    /(?i)authorization:\s+bearer\s+[A-Za-z0-9\-_\.=~+\/]+/,
  ].freeze
end
