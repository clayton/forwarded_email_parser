# frozen_string_literal: true

require_relative "forwarded_email_parser/parsed_email"
require_relative "forwarded_email_parser/version"
require_relative "forwarded_email_parser/utils"
require_relative "forwarded_email_parser/email_parser"
require_relative "forwarded_email_parser/parser"

module ForwardedEmailParser
  class Error < StandardError; end
end
