# frozen_string_literal: true

module ForwardedEmailParser
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

    def sender_name
      case @from
      when Hash
        @from[:name]
      when Array
        @from.reject { |f| f[:name].nil? }.first&.dig(:name)
      when String
        @from
      end
    end

    def sender_address
      case @from
      when Hash
        @from[:address]
      when Array
        @from.reject { |f| f[:address].nil? }.first&.dig(:address)
      when String
        @from
      end
    end

    def recipient_name
      case @to
      when Hash
        @to[:name]
      when Array
        @to.reject { |t| t[:name].nil? }.first&.dig(:name)
      when String
        @to
      end
    end

    def recipient_address
      case @to
      when Hash
        @to[:address]
      when Array
        @to.reject { |t| t[:address].nil? }.first&.dig(:address)
      when String
        @to
      end
    end
  end
end
