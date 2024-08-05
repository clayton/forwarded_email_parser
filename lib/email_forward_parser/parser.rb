# frozen_string_literal: true

module EmailForwardParser
  class Parser
    # Constructor
    def initialize
      @parser = EmailParser.new
    end

    # Attempts to parse a forwarded email
    # @param [String] body
    # @param [String, nil] subject
    # @return [Hash] The parsed email
    def parse(body, subject = nil)
      email = {}
      result = {}

      # Check if email was forwarded or not (via the subject)

      parsed_subject = @parser.parse_subject(subject) if subject
      forwarded = !subject.nil? && !parsed_subject.nil?

      # Check if email was forwarded or not (via the body)
      if !subject || forwarded
        result = @parser.parse_body(body, forwarded)
        if result[:email]
          forwarded = true
          email = @parser.parse_original_email(result[:email], result[:body])
        end
      end

      email[:subject] = parsed_subject if (email[:subject].nil? || email[:subject].empty?) && parsed_subject
      ParsedEmail.new(forwarded, result[:message], email)
    end
  end
end
