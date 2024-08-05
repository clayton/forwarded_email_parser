# frozen_string_literal: true

require "byebug"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "email_forward_parser"

require "minitest/autorun"

SUBJECT = "Integer consequat non purus"
BODY = "Aenean quis diam urna. Maecenas eleifend vulputate ligula ac consequat. Pellentesque cursus tincidunt mauris non venenatis.\nSed nec facilisis tellus. Nunc eget eros quis ex congue iaculis nec quis massa. Morbi in nisi tincidunt, euismod ante eget, eleifend nisi.\n\nPraesent ac ligula orci. Pellentesque convallis suscipit mi, at congue massa sagittis eget."
MESSAGE = "Praesent suscipit egestas hendrerit.\n\nAliquam eget dui dui."

FROM_ADDRESS = "john.doe@acme.com"
FROM_NAME = "John Doe"

TO_ADDRESS_1 = "bessie.berry@acme.com"
TO_NAME_1 = "Bessie Berry"
TO_ADDRESS_2 = "suzanne@globex.corp"
TO_NAME_2 = "Suzanne"

CC_ADDRESS_1 = "walter.sheltan@acme.com"
CC_NAME_1 = "Walter Sheltan"
CC_ADDRESS_2 = "nicholas@globex.corp"
CC_NAME_2 = "Nicholas"

def test_email(entry, email, opts = {})
  skip_to = entry.include?("outlook_2019_")
  skip_cc = entry.include?("outlook_2019_") || entry.include?("ionos_one_and_one_")

  skip_body = opts[:skip_body] || false
  skip_from = opts[:skip_from] || false
  skip_message = opts[:skip_message] || true

  assert !email.nil?

  assert_equal true, email.forwarded

  assert_equal SUBJECT, email.subject

  assert_equal BODY, email.body unless skip_body

  # Don't verify the value, as dates are localized by the email client
  assert_kind_of String, email.date
  assert (email.date || "").length > 1

  unless skip_from
    assert_equal FROM_ADDRESS, email.from.dig(:address)
    assert_equal FROM_NAME, email.from.dig(:name)
  end

  unless skip_to
    assert_equal TO_ADDRESS_1, email.to.dig(0, :address)
    assert_nil email.to.dig(0, :name)
  end

  return if skip_cc

  assert_equal CC_ADDRESS_1, email.cc.dig(0, :address)
  assert_equal CC_NAME_1, email.cc.dig(0, :name)
  assert_equal CC_ADDRESS_2, email.cc.dig(1, :address)
  assert_equal CC_NAME_2, email.cc.dig(1, :name)

  assert_equal MESSAGE, email.message unless skip_message
end

def parse_email(email_file, subject_file = nil)
  subject = nil

  email = File.read(File.join(__dir__, "fixtures", "#{email_file}.txt"))

  subject = File.read(File.join(__dir__, "fixtures", "#{subject_file}.txt")) if subject_file

  parser = EmailForwardParser::Parser.new
  parser.parse(email, subject)
end
