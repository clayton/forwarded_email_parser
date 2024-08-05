# frozen_string_literal: true

require_relative "email_forward_parser/parsed_email"
require_relative "email_forward_parser/version"
require_relative "email_forward_parser/utils"
require_relative "email_forward_parser/email_parser"
require_relative "email_forward_parser/parser"

module EmailForwardParser
  class Error < StandardError; end
end
