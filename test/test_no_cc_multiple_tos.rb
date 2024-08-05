# frozen_string_literal: true

require "test_helper"

class TestNoCcMultipleTos < Minitest::Test
  def setup
    @opts = {
      skip_to: true,
      skip_cc: true,
      skip_from: false,
      skip_message: true
    }
  end

  def test_apple_mail_en_body_variant_one
    parse_email("apple_mail_en_body_variant_1")
    skip "WIP" # test_email("apple_mail_en_body_variant_1", result, @opts)
  end

  # def test_gmail_en_body_variant_one
  #   result = parse_email("gmail_en_body_variant_1")
  #   test_email("gmail_en_body_variant_1", result, @opts)
  # end

  # def test_hubspot_en_body_variant_one
  #   result = parse_email("hubspot_en_body_variant_1")
  #   test_email("hubspot_en_body_variant_1", result, @opts)
  # end

  # def test_mailmate_en_body_variant_one
  #   result = parse_email("mailmate_en_body_variant_1")
  #   test_email("mailmate_en_body_variant_1", result, @opts)
  # end

  # def test_missive_en_body_variant_one
  #   result = parse_email("missive_en_body_variant_1")
  #   test_email("missive_en_body_variant_1", result, @opts)
  # end
end
