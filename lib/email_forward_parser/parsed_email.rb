# frozen_string_literal: true

module EmailForwardParser
  class ParsedEmail
    attr_accessor :forwarded, :message, :email, :subject, :date, :from, :to, :cc, :body

    def initialize(forwarded, message, email)
      @forwarded = forwarded
      @message = message
      @email = email

      @subject = email[:subject]
      @date = email[:date]
      @from = email[:from]
      @to = email[:to]
      @cc = email[:cc]
      @body = email[:body]
    end
  end
end
