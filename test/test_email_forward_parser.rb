# frozen_string_literal: true

require "test_helper"

class TestEmailForwardParser < Minitest::Test
  def test_apple_mail_cs_body
    result = parse_email("apple_mail_cs_body")
    test_email("apple_mail_cs_body", result)
  end

  def test_apple_mail_da_body
    result = parse_email("apple_mail_da_body")
    test_email("apple_mail_da_body", result)
  end

  def test_apple_mail_de_body
    result = parse_email("apple_mail_de_body")
    test_email("apple_mail_de_body", result)
  end

  def test_apple_mail_en_body
    result = parse_email("apple_mail_en_body")
    test_email("apple_mail_en_body", result)
  end

  def test_apple_mail_es_body
    result = parse_email("apple_mail_es_body")
    test_email("apple_mail_es_body", result)
  end

  def test_apple_mail_fi_body
    result = parse_email("apple_mail_fi_body")
    test_email("apple_mail_fi_body", result)
  end

  def test_apple_mail_fr_body
    result = parse_email("apple_mail_fr_body")
    test_email("apple_mail_fr_body", result)
  end

  def test_apple_mail_hr_body
    result = parse_email("apple_mail_hr_body")
    test_email("apple_mail_hr_body", result)
  end

  def test_apple_mail_hu_body
    result = parse_email("apple_mail_hu_body")
    test_email("apple_mail_hu_body", result)
  end

  def test_apple_mail_it_body
    result = parse_email("apple_mail_it_body")
    test_email("apple_mail_it_body", result)
  end

  def test_apple_mail_nl_body
    result = parse_email("apple_mail_nl_body")
    test_email("apple_mail_nl_body", result)
  end

  def test_apple_mail_no_body
    result = parse_email("apple_mail_no_body")
    test_email("apple_mail_no_body", result)
  end

  def test_apple_mail_pl_body
    result = parse_email("apple_mail_pl_body")
    test_email("apple_mail_pl_body", result)
  end

  def test_apple_mail_pt_br_body
    result = parse_email("apple_mail_pt_br_body")
    test_email("apple_mail_pt_br_body", result)
  end

  def test_apple_mail_pt_body
    result = parse_email("apple_mail_pt_body")
    test_email("apple_mail_pt_body", result)
  end

  def test_apple_mail_ro_body
    result = parse_email("apple_mail_ro_body")
    test_email("apple_mail_ro_body", result)
  end

  def test_apple_mail_ru_body
    result = parse_email("apple_mail_ru_body")
    test_email("apple_mail_ru_body", result)
  end

  def test_apple_mail_sk_body
    result = parse_email("apple_mail_sk_body")
    test_email("apple_mail_sk_body", result)
  end

  def test_apple_mail_sv_body
    result = parse_email("apple_mail_sv_body")
    test_email("apple_mail_sv_body", result)
  end

  def test_apple_mail_tr_body
    result = parse_email("apple_mail_tr_body")
    test_email("apple_mail_tr_body", result)
  end

  def test_apple_mail_uk_body
    result = parse_email("apple_mail_uk_body")
    test_email("apple_mail_uk_body", result)
  end

  def test_gmail_cs_body
    result = parse_email("gmail_cs_body")
    test_email("gmail_cs_body", result)
  end

  def test_gmail_da_body
    result = parse_email("gmail_da_body")
    test_email("gmail_da_body", result)
  end

  def test_gmail_en_body
    result = parse_email("gmail_en_body")
    test_email("gmail_en_body", result)
  end

  def test_gmail_es_body
    result = parse_email("gmail_es_body")
    test_email("gmail_es_body", result)
  end

  def test_gmail_et_body
    result = parse_email("gmail_et_body")
    test_email("gmail_et_body", result)
  end

  def test_gmail_fi_body
    result = parse_email("gmail_fi_body")
    test_email("gmail_fi_body", result)
  end

  def test_gmail_fr_body
    result = parse_email("gmail_fr_body")
    test_email("gmail_fr_body", result)
  end

  def test_gmail_hr_body
    result = parse_email("gmail_hr_body")
    test_email("gmail_hr_body", result)
  end

  def test_gmail_nl_body
    result = parse_email("gmail_nl_body")
    test_email("gmail_nl_body", result)
  end

  def test_gmail_no_body
    result = parse_email("gmail_no_body")
    test_email("gmail_no_body", result)
  end

  def test_gmail_pl_body
    result = parse_email("gmail_pl_body")
    test_email("gmail_pl_body", result)
  end

  def test_gmail_pt_body
    result = parse_email("gmail_pt_body")
    test_email("gmail_pt_body", result)
  end

  def test_gmail_ro_body
    result = parse_email("gmail_ro_body")
    test_email("gmail_ro_body", result)
  end

  def test_gmail_sk_body
    result = parse_email("gmail_sk_body")
    test_email("gmail_sk_body", result)
  end

  def test_gmail_sv_body
    result = parse_email("gmail_sv_body")
    test_email("gmail_sv_body", result)
  end

  def test_gmail_tr_body
    result = parse_email("gmail_tr_body")
    test_email("gmail_tr_body", result)
  end

  def test_gmail_uk_body
    result = parse_email("gmail_uk_body")
    test_email("gmail_uk_body", result)
  end

  def test_hubspot_de_body
    result = parse_email("hubspot_de_body")
    test_email("hubspot_de_body", result)
  end

  def test_hubspot_en_body
    result = parse_email("hubspot_en_body")
    test_email("hubspot_en_body", result)
  end

  def test_hubspot_es_body
    result = parse_email("hubspot_es_body")
    test_email("hubspot_es_body", result)
  end

  def test_hubspot_fi_body
    result = parse_email("hubspot_fi_body")
    test_email("hubspot_fi_body", result)
  end

  def test_hubspot_fr_body
    result = parse_email("hubspot_fr_body")
    test_email("hubspot_fr_body", result)
  end

  def test_hubspot_it_body
    result = parse_email("hubspot_it_body")
    test_email("hubspot_it_body", result)
  end

  def test_hubspot_ja_body
    result = parse_email("hubspot_ja_body")
    test_email("hubspot_ja_body", result)
  end

  def test_hubspot_nl_body
    result = parse_email("hubspot_nl_body")
    test_email("hubspot_nl_body", result)
  end

  def test_hubspot_pl_body
    result = parse_email("hubspot_pl_body")
    test_email("hubspot_pl_body", result)
  end

  def test_hubspot_pt_br_body
    result = parse_email("hubspot_pt_br_body")
    test_email("hubspot_pt_br_body", result)
  end

  def test_hubspot_sv_body
    result = parse_email("hubspot_sv_body")
    test_email("hubspot_sv_body", result)
  end

  def test_ionos_one_and_one_en_body
    result = parse_email("ionos_one_and_one_en_body")
    test_email("ionos_one_and_one_en_body", result)
  end

  def test_mailmate_en_body
    result = parse_email("mailmate_en_body")
    test_email("mailmate_en_body", result)
  end

  def test_missive_en_body
    result = parse_email("missive_en_body")
    test_email("missive_en_body", result)
  end

  def test_outlook_live_cs_subject
    result = parse_email("outlook_live_body", "outlook_live_cs_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_da_subject
    result = parse_email("outlook_live_body", "outlook_live_da_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_de_subject
    result = parse_email("outlook_live_body", "outlook_live_de_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_en_subject
    result = parse_email("outlook_live_body", "outlook_live_en_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_es_subject
    result = parse_email("outlook_live_body", "outlook_live_es_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_fr_subject
    result = parse_email("outlook_live_body", "outlook_live_fr_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_hr_subject
    result = parse_email("outlook_live_body", "outlook_live_hr_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_hu_subject
    result = parse_email("outlook_live_body", "outlook_live_hu_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_it_subject
    result = parse_email("outlook_live_body", "outlook_live_it_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_nl_subject
    result = parse_email("outlook_live_body", "outlook_live_nl_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_no_subject
    result = parse_email("outlook_live_body", "outlook_live_no_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_pl_subject
    result = parse_email("outlook_live_body", "outlook_live_pl_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_pt_br_subject
    result = parse_email("outlook_live_body", "outlook_live_pt_br_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_pt_subject
    result = parse_email("outlook_live_body", "outlook_live_pt_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_ro_subject
    result = parse_email("outlook_live_body", "outlook_live_ro_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_sk_subject
    result = parse_email("outlook_live_body", "outlook_live_sk_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_live_sv_subject
    result = parse_email("outlook_live_body", "outlook_live_sv_subject")
    test_email("outlook_live_body", result)
  end

  def test_outlook_2013_en_subject
    result = parse_email("outlook_2013_en_body", "outlook_2013_en_subject")
    test_email("outlook_2013_en_body", result)
  end

  def test_new_outlook_2019_cs_subject
    result = parse_email("new_outlook_2019_cs_body", "new_outlook_2019_cs_subject")
    test_email("new_outlook_2019_cs_body", result)
  end

  def test_new_outlook_2019_da_subject
    result = parse_email("new_outlook_2019_da_body", "new_outlook_2019_da_subject")
    test_email("new_outlook_2019_da_body", result)
  end

  def test_new_outlook_2019_de_subject
    result = parse_email("new_outlook_2019_de_body", "new_outlook_2019_de_subject")
    test_email("new_outlook_2019_de_body", result)
  end

  def test_new_outlook_2019_en_subject
    result = parse_email("new_outlook_2019_en_body", "new_outlook_2019_en_subject")
    test_email("new_outlook_2019_en_body", result)
  end

  def test_new_outlook_2019_es_subject
    result = parse_email("new_outlook_2019_es_body", "new_outlook_2019_es_subject")
    test_email("new_outlook_2019_es_body", result)
  end

  def test_new_outlook_2019_fi_subject
    result = parse_email("new_outlook_2019_fi_body", "new_outlook_2019_fi_subject")
    test_email("new_outlook_2019_fi_body", result)
  end

  def test_new_outlook_2019_fr_subject
    result = parse_email("new_outlook_2019_fr_body", "new_outlook_2019_fr_subject")
    test_email("new_outlook_2019_fr_body", result)
  end

  def test_new_outlook_2019_hu_subject
    result = parse_email("new_outlook_2019_hu_body", "new_outlook_2019_hu_subject")
    test_email("new_outlook_2019_hu_body", result)
  end

  def test_new_outlook_2019_it_subject
    result = parse_email("new_outlook_2019_it_body", "new_outlook_2019_it_subject")
    test_email("new_outlook_2019_it_body", result)
  end

  def test_new_outlook_2019_nl_subject
    result = parse_email("new_outlook_2019_nl_body", "new_outlook_2019_nl_subject")
    test_email("new_outlook_2019_nl_body", result)
  end

  def test_new_outlook_2019_no_subject
    result = parse_email("new_outlook_2019_no_body", "new_outlook_2019_no_subject")
    test_email("new_outlook_2019_no_body", result)
  end

  def test_new_outlook_2019_pl_subject
    result = parse_email("new_outlook_2019_pl_body", "new_outlook_2019_pl_subject")
    test_email("new_outlook_2019_pl_body", result)
  end

  def test_new_outlook_2019_pt_br_subject
    result = parse_email("new_outlook_2019_pt_br_body", "new_outlook_2019_pt_br_subject")
    test_email("new_outlook_2019_pt_br_body", result)
  end

  def test_new_outlook_2019_ru_subject
    result = parse_email("new_outlook_2019_ru_body", "new_outlook_2019_ru_subject")
    test_email("new_outlook_2019_ru_body", result)
  end

  def test_new_outlook_2019_sk_subject
    result = parse_email("new_outlook_2019_sk_body", "new_outlook_2019_sk_subject")
    test_email("new_outlook_2019_sk_body", result)
  end

  def test_new_outlook_2019_sv_subject
    result = parse_email("new_outlook_2019_sv_body", "new_outlook_2019_sv_subject")
    test_email("new_outlook_2019_sv_body", result)
  end

  def test_new_outlook_2019_tr_subject
    result = parse_email("new_outlook_2019_tr_body", "new_outlook_2019_tr_subject")
    test_email("new_outlook_2019_tr_body", result)
  end

  def test_outlook_2019_cz_subject
    result = parse_email("outlook_2019_cz_body", "outlook_2019_subject")
    test_email("outlook_2019_cz_body", result)
  end

  def test_outlook_2019_da_subject
    result = parse_email("outlook_2019_da_body", "outlook_2019_subject")
    test_email("outlook_2019_da_body", result)
  end

  def test_outlook_2019_de_subject
    result = parse_email("outlook_2019_de_body", "outlook_2019_subject")
    test_email("outlook_2019_de_body", result)
  end

  def test_outlook_2019_en_subject
    result = parse_email("outlook_2019_en_body", "outlook_2019_subject")
    test_email("outlook_2019_en_body", result)
  end

  def test_outlook_2019_es_subject
    result = parse_email("outlook_2019_es_body", "outlook_2019_subject")
    test_email("outlook_2019_es_body", result)
  end

  def test_outlook_2019_fi_subject
    result = parse_email("outlook_2019_fi_body", "outlook_2019_subject")
    test_email("outlook_2019_fi_body", result)
  end

  def test_outlook_2019_fr_subject
    result = parse_email("outlook_2019_fr_body", "outlook_2019_subject")
    test_email("outlook_2019_fr_body", result)
  end

  def test_outlook_2019_hu_subject
    result = parse_email("outlook_2019_hu_body", "outlook_2019_subject")
    test_email("outlook_2019_hu_body", result)
  end

  def test_outlook_2019_it_subject
    result = parse_email("outlook_2019_it_body", "outlook_2019_subject")
    test_email("outlook_2019_it_body", result)
  end

  def test_outlook_2019_nl_subject
    result = parse_email("outlook_2019_nl_body", "outlook_2019_subject")
    test_email("outlook_2019_nl_body", result)
  end

  def test_outlook_2019_no_subject
    result = parse_email("outlook_2019_no_body", "outlook_2019_subject")
    test_email("outlook_2019_no_body", result)
  end

  def test_outlook_2019_pl_subject
    result = parse_email("outlook_2019_pl_body", "outlook_2019_subject")
    test_email("outlook_2019_pl_body", result)
  end

  def test_outlook_2019_pt_subject
    result = parse_email("outlook_2019_pt_body", "outlook_2019_subject")
    test_email("outlook_2019_pt_body", result)
  end

  def test_outlook_2019_ru_subject
    result = parse_email("outlook_2019_ru_body", "outlook_2019_subject")
    test_email("outlook_2019_ru_body", result)
  end

  def test_outlook_2019_sk_subject
    result = parse_email("outlook_2019_sk_body", "outlook_2019_subject")
    test_email("outlook_2019_sk_body", result)
  end

  def test_outlook_2019_sv_subject
    result = parse_email("outlook_2019_sv_body", "outlook_2019_subject")
    test_email("outlook_2019_sv_body", result)
  end

  def test_outlook_2019_tr_subject
    result = parse_email("outlook_2019_tr_body", "outlook_2019_subject")
    test_email("outlook_2019_tr_body", result)
  end

  def test_thunderbird_cs_body
    result = parse_email("thunderbird_cs_body")
    test_email("thunderbird_cs_body", result)
  end

  def test_thunderbird_en_body
    result = parse_email("thunderbird_en_body")
    test_email("thunderbird_en_body", result)
  end

  def test_thunderbird_fi_body
    result = parse_email("thunderbird_fi_body")
    test_email("thunderbird_fi_body", result)
  end

  def test_thunderbird_it_body
    result = parse_email("thunderbird_it_body")
    test_email("thunderbird_it_body", result)
  end

  def test_thunderbird_nl_body
    result = parse_email("thunderbird_nl_body")
    test_email("thunderbird_nl_body", result)
  end

  def test_thunderbird_no_body
    result = parse_email("thunderbird_no_body")
    test_email("thunderbird_no_body", result)
  end

  def test_thunderbird_pt_br_body
    result = parse_email("thunderbird_pt_br_body")
    test_email("thunderbird_pt_br_body", result)
  end

  def test_thunderbird_pt_body
    result = parse_email("thunderbird_pt_body")
    test_email("thunderbird_pt_body", result)
  end

  def test_thunderbird_ru_body
    result = parse_email("thunderbird_ru_body")
    test_email("thunderbird_ru_body", result)
  end

  def test_thunderbird_sk_body
    result = parse_email("thunderbird_sk_body")
    test_email("thunderbird_sk_body", result)
  end

  def test_thunderbird_uk_body
    result = parse_email("thunderbird_uk_body")
    test_email("thunderbird_uk_body", result)
  end

  def test_yahoo_cs_body
    result = parse_email("yahoo_cs_body")
    test_email("yahoo_cs_body", result)
  end

  def test_yahoo_da_body
    result = parse_email("yahoo_da_body")
    test_email("yahoo_da_body", result)
  end

  def test_yahoo_de_body
    result = parse_email("yahoo_de_body")
    test_email("yahoo_de_body", result)
  end

  def test_yahoo_en_body
    result = parse_email("yahoo_en_body")
    test_email("yahoo_en_body", result)
  end

  def test_yahoo_es_body
    result = parse_email("yahoo_es_body")
    test_email("yahoo_es_body", result)
  end

  def test_yahoo_fi_body
    result = parse_email("yahoo_fi_body")
    test_email("yahoo_fi_body", result)
  end

  def test_yahoo_fr_body
    result = parse_email("yahoo_fr_body")
    test_email("yahoo_fr_body", result)
  end

  def test_yahoo_hu_body
    result = parse_email("yahoo_hu_body")
    test_email("yahoo_hu_body", result)
  end

  def test_yahoo_it_body
    result = parse_email("yahoo_it_body")
    test_email("yahoo_it_body", result)
  end

  def test_yahoo_nl_body
    result = parse_email("yahoo_nl_body")
    test_email("yahoo_nl_body", result)
  end

  def test_yahoo_no_body
    result = parse_email("yahoo_no_body")
    test_email("yahoo_no_body", result)
  end

  def test_yahoo_pl_body
    result = parse_email("yahoo_pl_body")
    test_email("yahoo_pl_body", result)
  end

  def test_yahoo_pt_body
    result = parse_email("yahoo_pt_body")
    test_email("yahoo_pt_body", result)
  end

  def test_yahoo_pt_br_body
    result = parse_email("yahoo_pt_br_body")
    test_email("yahoo_pt_br_body", result)
  end

  def test_yahoo_ro_body
    result = parse_email("yahoo_ro_body")
    test_email("yahoo_ro_body", result)
  end

  def test_yahoo_ru_body
    result = parse_email("yahoo_ru_body")
    test_email("yahoo_ru_body", result)
  end

  def test_yahoo_sk_body
    result = parse_email("yahoo_sk_body")
    test_email("yahoo_sk_body", result)
  end

  def test_yahoo_sv_body
    result = parse_email("yahoo_sv_body")
    test_email("yahoo_sv_body", result)
  end

  def test_yahoo_tr_body
    result = parse_email("yahoo_tr_body")
    test_email("yahoo_tr_body", result)
  end

  def test_yahoo_uk_body
    result = parse_email("yahoo_uk_body")
    test_email("yahoo_uk_body", result)
  end
end
