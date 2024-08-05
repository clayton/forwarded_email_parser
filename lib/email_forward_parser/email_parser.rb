# frozen_string_literal: true

module EmailForwardParser
  class EmailParser
    MAILBOXES_SEPARATORS = [
      ",", # Apple Mail, Gmail, New Outlook 2019, Thunderbird
      ";" # Outlook Live / 365, Yahoo Mail
    ].freeze

    LINE_REGEXES = %i[
      separator
      original_subject
      original_subject_lax
      original_to
      original_reply_to
      original_cc
      original_date
    ].freeze

    REGEXES = {
      quote_line_break: /^(>+)\s?$/m, # Apple Mail, Missive
      quote: /^(>+)\s?/m, # Apple Mail
      four_spaces: /^(\ {4})\s?/m, # Outlook 2019
      carriage_return: /\r\n/m, # Outlook 2019
      byte_order_mark: /\uFEFF/m, # Outlook 2019
      trailing_non_breaking_space: /\u00A0$/m, # IONOS by 1 & 1
      non_breaking_space: /\u00A0/m, # HubSpot

      subject: [
        /^Fw:(.*)/,  # Outlook Live / 365 (cs, en, hr, hu, sk), Yahoo Mail (all locales)
        /^VS:(.*)/,  # Outlook Live / 365 (da), New Outlook 2019 (da)
        /^WG:(.*)/,  # Outlook Live / 365 (de), New Outlook 2019 (de)
        /^RV:(.*)/,  # Outlook Live / 365 (es), New Outlook 2019 (es)
        /^TR:(.*)/,  # Outlook Live / 365 (fr), New Outlook 2019 (fr)
        /^I:(.*)/,   # Outlook Live / 365 (it), New Outlook 2019 (it)
        /^FW:(.*)/,  # Outlook Live / 365 (nl, pt), New Outlook 2019 (cs, en, hu, nl, pt, ru, sk), Outlook 2019 (all locales)
        /^Vs:(.*)/,  # Outlook Live / 365 (no)
        /^PD:(.*)/,  # Outlook Live / 365 (pl), New Outlook 2019 (pl)
        /^ENC:(.*)/, # Outlook Live / 365 (pt-br), New Outlook 2019 (pt-br)
        /^Redir.:(.*)/, # Outlook Live / 365 (ro)
        /^VB:(.*)/,  # Outlook Live / 365 (sv), New Outlook 2019 (sv)
        /^VL:(.*)/,  # New Outlook 2019 (fi)
        /^Videresend:(.*)/, # New Outlook 2019 (no)
        /^İLT:(.*)/, # New Outlook 2019 (tr)
        /^Fwd:(.*)/  # Gmail (all locales), Thunderbird (all locales), Missive (en), MailMate (en)
      ],

      separator: [
        /^>?\s*Begin forwarded message\s?:/, # Apple Mail (en)
        /^>?\s*Začátek přeposílané zprávy\s?:/, # Apple Mail (cs)
        /^>?\s*Start på videresendt besked\s?:/, # Apple Mail (da)
        /^>?\s*Anfang der weitergeleiteten Nachricht\s?:/, # Apple Mail (de)
        /^>?\s*Inicio del mensaje reenviado\s?:/, # Apple Mail (es)
        /^>?\s*Välitetty viesti alkaa\s?:/, # Apple Mail (fi)
        /^>?\s*Début du message réexpédié\s?:/, # Apple Mail (fr)
        /^>?\s*Début du message transféré\s?:/, # Apple Mail iOS (fr)
        /^>?\s*Započni proslijeđenu poruku\s?:/, # Apple Mail (hr)
        /^>?\s*Továbbított levél kezdete\s?:/, # Apple Mail (hu)
        /^>?\s*Inizio messaggio inoltrato\s?:/, # Apple Mail (it)
        /^>?\s*Begin doorgestuurd bericht\s?:/, # Apple Mail (nl)
        /^>?\s*Videresendt melding\s?:/, # Apple Mail (no)
        /^>?\s*Początek przekazywanej wiadomości\s?:/, # Apple Mail (pl)
        /^>?\s*Início da mensagem reencaminhada\s?:/, # Apple Mail (pt)
        /^>?\s*Início da mensagem encaminhada\s?:/, # Apple Mail (pt-br)
        /^>?\s*Începe mesajul redirecționat\s?:/, # Apple Mail (ro)
        /^>?\s*Начало переадресованного сообщения\s?:/, # Apple Mail (ro)
        /^>?\s*Začiatok preposlanej správy\s?:/, # Apple Mail (sk)
        /^>?\s*Vidarebefordrat mejl\s?:/, # Apple Mail (sv)
        /^>?\s*İleti başlangıcı\s?:/, # Apple Mail (tr)
        /^>?\s*Початок листа, що пересилається\s?:/, # Apple Mail (uk)
        /^\s*-{8,10}\s*Forwarded message\s*-{8,10}\s*/, # Gmail (all locales), Missive (en), HubSpot (en)
        /^\s*_{32}\s*$/, # Outlook Live / 365 (all locales)
        /^\s?Forwarded message:/, # Mailmate
        /^\s?Dne\s?.+,\s?.+\s*[\[|<].+[\]|>]\s?napsal\(a\)\s?:/, # Outlook 2019 (cz)
        /^\s?D.\s?.+\s?skrev\s?".+"\s*[\[|<].+[\]|>]\s?:/, # Outlook 2019 (da)
        /^\s?Am\s?.+\s?schrieb\s?".+"\s*[\[|<].+[\]|>]\s?:/, # Outlook 2019 (de)
        /^\s?On\s?.+,\s?".+"\s*[\[|<].+[\]|>]\s?wrote\s?:/, # Outlook 2019 (en)
        /^\s?El\s?.+,\s?".+"\s*[\[|<].+[\]|>]\s?escribió\s?:/, # Outlook 2019 (es)
        /^\s?Le\s?.+,\s?«.+»\s*[\[|<].+[\]|>]\s?a écrit\s?:/, # Outlook 2019 (fr)
        /^\s?.+\s*[\[|<].+[\]|>]\s?kirjoitti\s?.+\s?:/, # Outlook 2019 (fi)
        /^\s?.+\s?időpontban\s?.+\s*[\[|<|(].+[\]|>|)]\s?ezt írta\s?:/, # Outlook 2019 (hu)
        /^\s?Il giorno\s?.+\s?".+"\s*[\[|<].+[\]|>]\s?ha scritto\s?:/, # Outlook 2019 (it)
        /^\s?Op\s?.+\s?heeft\s?.+\s*[\[|<].+[\]|>]\s?geschreven\s?:/, # Outlook 2019 (nl)
        /^\s?.+\s*[\[|<].+[\]|>]\s?skrev følgende den\s?.+\s?:/, # Outlook 2019 (no)
        /^\s?Dnia\s?.+\s?„.+”\s*[\[|<].+[\]|>]\s?napisał\s?:/, # Outlook 2019 (pl)
        /^\s?Em\s?.+,\s?".+"\s*[\[|<].+[\]|>]\s?escreveu\s?:/, # Outlook 2019 (pt)
        /^\s?.+\s?пользователь\s?".+"\s*[\[|<].+[\]|>]\s?написал\s?:/, # Outlook 2019 (ru)
        /^\s?.+\s?používateľ\s?.+\s*\([\[|<].+[\]|>]\)\s?napísal\s?:/, # Outlook 2019 (sk)
        /^\s?Den\s?.+\s?skrev\s?".+"\s*[\[|<].+[\]|>]\s?följande\s?:/, # Outlook 2019 (sv)
        /^\s?".+"\s*[\[|<].+[\]|>],\s?.+\s?tarihinde şunu yazdı\s?:/, # Outlook 2019 (tr)
        /^\s*-{5,8} Přeposlaná zpráva -{5,8}\s*/, # Yahoo Mail (cs), Thunderbird (cs)
        /^\s*-{5,8} Videresendt meddelelse -{5,8}\s*/, # Yahoo Mail (da), Thunderbird (da)
        /^\s*-{5,10} Weitergeleitete Nachricht -{5,10}\s*/, # Yahoo Mail (de), Thunderbird (de), HubSpot (de)
        /^\s*-{5,8} Forwarded Message -{5,8}\s*/, # Yahoo Mail (en), Thunderbird (en)
        /^\s*-{5,10} Mensaje reenviado -{5,10}\s*/, # Yahoo Mail (es), Thunderbird (es), HubSpot (es)
        /^\s*-{5,10} Edelleenlähetetty viesti -{5,10}\s*/, # Yahoo Mail (fi), HubSpot (fi)
        /^\s*-{5} Message transmis -{5}\s*/, # Yahoo Mail (fr)
        /^\s*-{5,8} Továbbított üzenet -{5,8}\s*/, # Yahoo Mail (hu), Thunderbird (hu)
        /^\s*-{5,10} Messaggio inoltrato -{5,10}\s*/, # Yahoo Mail (it), HubSpot (it)
        /^\s*-{5,10} Doorgestuurd bericht -{5,10}\s*/, # Yahoo Mail (nl), Thunderbird (nl), HubSpot (nl)
        /^\s*-{5,8} Videresendt melding -{5,8}\s*/, # Yahoo Mail (no), Thunderbird (no)
        /^\s*-{5} Przekazana wiadomość -{5}\s*/, # Yahoo Mail (pl)
        /^\s*-{5,8} Mensagem reencaminhada -{5,8}\s*/, # Yahoo Mail (pt), Thunderbird (pt)
        /^\s*-{5,10} Mensagem encaminhada -{5,10}\s*/, # Yahoo Mail (pt-br), Thunderbird (pt-br), HubSpot (pt-br)
        /^\s*-{5,8} Mesaj redirecționat -{5,8}\s*/, # Yahoo Mail (ro)
        /^\s*-{5} Пересылаемое сообщение -{5}\s*/, # Yahoo Mail (ru)
        /^\s*-{5} Preposlaná správa -{5}\s*/, # Yahoo Mail (sk)
        /^\s*-{5,10} Vidarebefordrat meddelande -{5,10}\s*/, # Yahoo Mail (sv), Thunderbird (sv), HubSpot (sv)
        /^\s*-{5} İletilmiş Mesaj -{5}\s*/, # Yahoo Mail (tr)
        /^\s*-{5} Перенаправлене повідомлення -{5}\s*/, # Yahoo Mail (uk)
        %r{^\s*-{8} Välitetty viesti / Fwd.Msg -{8}\s*}m, # Thunderbird (fi)
        /^\s*-{8,10} Message transféré -{8,10}\s*/, # Thunderbird (fr), HubSpot (fr)
        /^\s*-{8} Proslijeđena poruka -{8}\s*/, # Thunderbird (hr)
        /^\s*-{8} Messaggio Inoltrato -{8}\s*/, # Thunderbird (it)
        /^\s*-{3} Treść przekazanej wiadomości -{3}\s*/, # Thunderbird (pl)
        /^\s*-{8} Перенаправленное сообщение -{8}\s*/, # Thunderbird (ru)
        /^\s*-{8} Preposlaná správa --- Forwarded Message -{8}\s*/, # Thunderbird (sk)
        /^\s*-{8} İletilen İleti -{8}\s*/, # Thunderbird (tr)
        /^\s*-{8} Переслане повідомлення -{8}\s*/, # Thunderbird (uk)
        /^\s*-{9,10} メッセージを転送 -{9,10}\s*/, # HubSpot (ja)
        /^\s*-{9,10} Wiadomość przesłana dalej -{9,10}\s*/, # HubSpot (pl)
        /^>?\s*-{10} Original Message -{10}\s*/ # IONOS by 1 & 1 (en)
      ],

      separator_with_information: [
        /^\s?Dne\s?(?<date>.+),\s?(?<from_name>.+)\s*[\[|<](?<from_address>.+)[\]|>]\s?napsal\(a\)\s?:/, # Outlook 2019 (cz)
        /^\s?D.\s?(?<date>.+)\s?skrev\s?"(?<from_name>.+)"\s*[\[|<](?<from_address>.+)[\]|>]\s?:/, # Outlook 2019 (da)
        /^\s?Am\s?(?<date>.+)\s?schrieb\s?"(?<from_name>.+)"\s*[\[|<](?<from_address>.+)[\]|>]\s?:/, # Outlook 2019 (de)
        /^\s?On\s?(?<date>.+),\s?"(?<from_name>.+)"\s*[\[|<](?<from_address>.+)[\]|>]\s?wrote\s?:/, # Outlook 2019 (en)
        /^\s?El\s?(?<date>.+),\s?"(?<from_name>.+)"\s*[\[|<](?<from_address>.+)[\]|>]\s?escribió\s?:/, # Outlook 2019 (es)
        /^\s?Le\s?(?<date>.+),\s?«(?<from_name>.+)»\s*[\[|<](?<from_address>.+)[\]|>]\s?a écrit\s?:/, # Outlook 2019 (fr)
        /^\s?(?<from_name>.+)\s*[\[|<](?<from_address>.+)[\]|>]\s?kirjoitti\s?(?<date>.+)\s?:/, # Outlook 2019 (fi)
        /^\s?(?<date>.+)\s?időpontban\s?(?<from_name>.+)\s*[\[|<|(](?<from_address>.+)[\]|>|)]\s?ezt írta\s?:/, # Outlook 2019 (hu)
        /^\s?Il giorno\s?(?<date>.+)\s?"(?<from_name>.+)"\s*[\[|<](?<from_address>.+)[\]|>]\s?ha scritto\s?:/, # Outlook 2019 (it)
        /^\s?Op\s?(?<date>.+)\s?heeft\s?(?<from_name>.+)\s*[\[|<](?<from_address>.+)[\]|>]\s?geschreven\s?:/, # Outlook 2019 (nl)
        /^\s?(?<from_name>.+)\s*[\[|<](?<from_address>.+)[\]|>]\s?skrev følgende den\s?(?<date>.+)\s?:/, # Outlook 2019 (no)
        /^\s?Dnia\s?(?<date>.+)\s?„(?<from_name>.+)”\s*[\[|<](?<from_address>.+)[\]|>]\s?napisał\s?:/, # Outlook 2019 (pl)
        /^\s?Em\s?(?<date>.+),\s?"(?<from_name>.+)"\s*[\[|<](?<from_address>.+)[\]|>]\s?escreveu\s?:/, # Outlook 2019 (pt)
        /^\s?(?<date>.+)\s?пользователь\s?"(?<from_name>.+)"\s*[\[|<](?<from_address>.+)[\]|>]\s?написал\s?:/, # Outlook 2019 (ru)
        /^\s?(?<date>.+)\s?používateľ\s?(?<from_name>.+)\s*\([\[|<](?<from_address>.+)[\]|>]\)\s?napísal\s?:/, # Outlook 2019 (sk)
        /^\s?Den\s?(?<date>.+)\s?skrev\s?"(?<from_name>.+)"\s*[\[|<](?<from_address>.+)[\]|>]\s?följande\s?:/, # Outlook 2019 (sv)
        /^\s?"(?<from_name>.+)"\s*[\[|<](?<from_address>.+)[\]|>],\s?(?<date>.+)\s?tarihinde şunu yazdı\s?:/ # Outlook 2019 (tr)
      ],

      original_subject: [
        /^\*?Subject\s?:\*?(.+)/i, # Apple Mail (en), Gmail (all locales), Outlook Live / 365 (all locales), New Outlook 2019 (en), Thunderbird (da, en), Missive (en), HubSpot (en)
        /^Předmět\s?:(.+)/i, # Apple Mail (cs), New Outlook 2019 (cs), Thunderbird (cs)
        /^Emne\s?:(.+)/i, # Apple Mail (da, no), New Outlook 2019 (da), Thunderbird (no)
        /^Betreff\s?:(.+)/i, # Apple Mail (de), New Outlook 2019 (de), Thunderbird (de), HubSpot (de)
        /^Asunto\s?:(.+)/i, # Apple Mail (es), New Outlook 2019 (es), Thunderbird (es), HubSpot (es)
        /^Aihe\s?:(.+)/i, # Apple Mail (fi), New Outlook 2019 (fi), Thunderbird (fi), HubSpot (fi)
        /^Objet\s?:(.+)/i, # Apple Mail (fr), New Outlook 2019 (fr), HubSpot (fr)
        /^Predmet\s?:(.+)/i, # Apple Mail (hr, sk), New Outlook 2019 (sk), Thunderbird (sk)
        /^Tárgy\s?:(.+)/i, # Apple Mail (hu), New Outlook 2019 (hu), Thunderbird (hu)
        /^Oggetto\s?:(.+)/i, # Apple Mail (it), New Outlook 2019 (it), Thunderbird (it), HubSpot (it)
        /^Onderwerp\s?:(.+)/i, # Apple Mail (nl), New Outlook 2019 (nl), Thunderbird (nl), HubSpot (nl)
        /^Temat\s?:(.+)/i, # Apple Mail (pl), New Outlook 2019 (pl), Thunderbird (pl), HubSpot (pl)
        /^Assunto\s?:(.+)/i, # Apple Mail (pt, pt-br), New Outlook 2019 (pt, pt-br), Thunderbird (pt, pt-br), HubSpot (pt-br)
        /^Subiectul\s?:(.+)/i, # Apple Mail (ro), Thunderbird (ro)
        /^Тема\s?:(.+)/i, # Apple Mail (ru, uk), New Outlook 2019 (ru), Thunderbird (ru, uk)
        /^Ämne\s?:(.+)/i, # Apple Mail (sv), New Outlook 2019 (sv), Thunderbird (sv), HubSpot (sv)
        /^Konu\s?:(.+)/i, # Apple Mail (tr), Thunderbird (tr)
        /^Sujet\s?:(.+)/i, # Thunderbird (fr)
        /^Naslov\s?:(.+)/i, # Thunderbird (hr)
        /^件名：(.+)/i # HubSpot (ja)
      ],

      original_subject_lax: [
        /Subject\s?:(.+)/i, # Yahoo Mail (en)
        /Emne\s?:(.+)/i, # Yahoo Mail (da, no)
        /Předmět\s?:(.+)/i, # Yahoo Mail (cs)
        /Betreff\s?:(.+)/i, # Yahoo Mail (de)
        /Asunto\s?:(.+)/i, # Yahoo Mail (es)
        /Aihe\s?:(.+)/i, # Yahoo Mail (fi)
        /Objet\s?:(.+)/i, # Yahoo Mail (fr)
        /Tárgy\s?:(.+)/i, # Yahoo Mail (hu)
        /Oggetto\s?:(.+)/i, # Yahoo Mail (it)
        /Onderwerp\s?:(.+)/i, # Yahoo Mail (nl)
        /Assunto\s?:?(.+)/i, # Yahoo Mail (pt, pt-br)
        /Temat\s?:(.+)/i, # Yahoo Mail (pl)
        /Subiect\s?:(.+)/i, # Yahoo Mail (ro)
        /Тема\s?:(.+)/i, # Yahoo Mail (ru, uk)
        /Predmet\s?:(.+)/i, # Yahoo Mail (sk)
        /Ämne\s?:(.+)/i, # Yahoo Mail (sv)
        /Konu\s?:(.+)/i # Yahoo Mail (tr)
      ],

      original_from: [
        /^(\*?\s*From\s?:\*?(.+))$/, # Apple Mail (en), Outlook Live / 365 (all locales), New Outlook 2019 (en), Thunderbird (da, en), Missive (en), HubSpot (en)
        /^(\s*Od\s?:(.+))$/, # Apple Mail (cs, pl, sk), Gmail (cs, pl, sk), New Outlook 2019 (cs, pl, sk), Thunderbird (cs, sk), HubSpot (pl)
        /^(\s*Fra\s?:(.+))$/, # Apple Mail (da, no), Gmail (da, no), New Outlook 2019 (da), Thunderbird (no)
        /^(\s*Von\s?:(.+))$/, # Apple Mail (de), Gmail (de), New Outlook 2019 (de), Thunderbird (de), HubSpot (de)
        /^(\s*De\s?:(.+))$/, # Apple Mail (es, fr, pt, pt-br), Gmail (es, fr, pt, pt-br), New Outlook 2019 (es, fr, pt, pt-br), Thunderbird (fr, pt, pt-br), HubSpot (es, fr, pt-br)
        /^(\s*Lähettäjä\s?:(.+))$/, # Apple Mail (fi), Gmail (fi), New Outlook 2019 (fi), Thunderbird (fi), HubSpot (fi)
        /^(\s*Šalje\s?:(.+))$/, # Apple Mail (hr), Gmail (hr), Thunderbird (hr)
        /^(\s*Feladó\s?:(.+))$/, # Apple Mail (hu), Gmail (hu), New Outlook 2019 (fr), Thunderbird (hu)
        /^(\s*Da\s?:(.+))$/, # Apple Mail (it), Gmail (it), New Outlook 2019 (it), HubSpot (it)
        /^(\s*Van\s?:(.+))$/, # Apple Mail (nl), Gmail (nl), New Outlook 2019 (nl), Thunderbird (nl), HubSpot (nl)
        /^(\s*Expeditorul\s?:(.+))$/, # Apple Mail (ro)
        /^(\s*Отправитель\s?:(.+))$/, # Apple Mail (ru)
        /^(\s*Från\s?:(.+))$/, # Apple Mail (sv), Gmail (sv), New Outlook 2019 (sv), Thunderbird (sv), HubSpot (sv)
        /^(\s*Kimden\s?:(.+))$/, # Apple Mail (tr), Thunderbird (tr)
        /^(\s*Від кого\s?:(.+))$/, # Apple Mail (uk)
        /^(\s*Saatja\s?:(.+))$/, # Gmail (et)
        /^(\s*De la\s?:(.+))$/, # Gmail (ro)
        /^(\s*Gönderen\s?:(.+))$/, # Gmail (tr)
        /^(\s*От\s?:(.+))$/, # Gmail (ru), New Outlook 2019 (ru), Thunderbird (ru)
        /^(\s*Від\s?:(.+))$/, # Gmail (uk), Thunderbird (uk)
        /^(\s*Mittente\s?:(.+))$/, # Thunderbird (it)
        /^(\s*Nadawca\s?:(.+))$/, # Thunderbird (pl)
        /^(\s*de la\s?:(.+))$/, # Thunderbird (ro)
        /^(\s*送信元：(.+))$/ # HubSpot (ja)
      ],

      original_from_lax: [
        /(\s*From\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (en)
        /(\s*Od\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (cs, pl, sk)
        /(\s*Fra\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (da, no)
        /(\s*Von\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (de)
        /(\s*De\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (es, fr, pt, pt-br)
        /(\s*Lähettäjä\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (fi)
        /(\s*Feladó\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (hu)
        /(\s*Da\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (it)
        /(\s*Van\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (nl)
        /(\s*De la\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (ro)
        /(\s*От\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (ru)
        /(\s*Från\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (sv)
        /(\s*Kimden\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/, # Yahoo Mail (tr)
        /(\s*Від\s?:(.+?)\s?\n?\s*[\[|<](.+?)[\]|>])/ # Yahoo Mail (uk)
      ],

      original_to: [
        /^\*?\s*To\s?:\*?(.+)$/, # Apple Mail (en), Gmail (all locales), Outlook Live / 365 (all locales), Thunderbird (da, en), Missive (en), HubSpot (en)
        /^\s*Komu\s?:(.+)$/, # Apple Mail (cs), New Outlook 2019 (cs, sk), Thunderbird (cs)
        /^\s*Til\s?:(.+)$/, # Apple Mail (da, no), New Outlook 2019 (da), Thunderbird (no)
        /^\s*An\s?:(.+)$/, # Apple Mail (de), New Outlook 2019 (de), Thunderbird (de), HubSpot (de)
        /^\s*Para\s?:(.+)$/, # Apple Mail (es, pt, pt-br), New Outlook 2019 (es, pt, pt-br), Thunderbird (es, pt, pt-br), HubSpot (pt-br)
        /^\s*Vastaanottaja\s?:(.+)$/, # Apple Mail (fi), New Outlook 2019 (fi), Thunderbird (fi), HubSpot (fi)
        /^\s*À\s?:(.+)$/, # Apple Mail (fr), New Outlook 2019 (fr), HubSpot (fr)
        /^\s*Prima\s?:(.+)$/, # Apple Mail (hr), Thunderbird (hr)
        /^\s*Címzett\s?:(.+)$/, # Apple Mail (hu), New Outlook 2019 (hu), Thunderbird (hu)
        /^\s*A\s?:(.+)$/, # Apple Mail (it), New Outlook 2019 (it), Thunderbird (it), HubSpot (es, it)
        /^\s*Aan\s?:(.+)$/, # Apple Mail (nl), New Outlook 2019 (nl), Thunderbird (nl), HubSpot (nl)
        /^\s*Do\s?:(.+)$/, # Apple Mail (pl), New Outlook 2019 (pl), HubSpot (pl)
        /^\s*Destinatarul\s?:(.+)$/, # Apple Mail (ro)
        /^\s*Кому\s?:(.+)$/, # Apple Mail (ru, uk), New Outlook 2019 (ru), Thunderbird (ru, uk)
        /^\s*Pre\s?:(.+)$/, # Apple Mail (sk), Thunderbird (sk)
        /^\s*Till\s?:(.+)$/, # Apple Mail (sv), New Outlook 2019 (sv), Thunderbird (sv)
        /^\s*Kime\s?:(.+)$/, # Apple Mail (tr), Thunderbird (tr)
        /^\s*Pour\s?:(.+)$/, # Thunderbird (fr)
        /^\s*Adresat\s?:(.+)$/, # Thunderbird (pl)
        /^\s*送信先：(.+)$/ # HubSpot (ja)
      ],

      original_to_lax: [
        /\s*To\s?:(.+)$/, # Yahook Mail (en)
        /\s*Komu\s?:(.+)$/, # Yahook Mail (cs, sk)
        /\s*Til\s?:(.+)$/, # Yahook Mail (da, no, sv)
        /\s*An\s?:(.+)$/, # Yahook Mail (de)
        /\s*Para\s?:(.+)$/, # Yahook Mail (es, pt, pt-br)
        /\s*Vastaanottaja\s?:(.+)$/, # Yahook Mail (fi)
        /\s*À\s?:(.+)$/, # Yahook Mail (fr)
        /\s*Címzett\s?:(.+)$/, # Yahook Mail (hu)
        /\s*A\s?:(.+)$/, # Yahook Mail (it)
        /\s*Aan\s?:(.+)$/, # Yahook Mail (nl)
        /\s*Do\s?:(.+)$/, # Yahook Mail (pl)
        /\s*Către\s?:(.+)$/, # Yahook Mail (ro), Thunderbird (ro)
        /\s*Кому\s?:(.+)$/, # Yahook Mail (ru, uk)
        /\s*Till\s?:(.+)$/, # Yahook Mail (sv)
        /\s*Kime\s?:(.+)$/ # Yahook Mail (tr)
      ],

      original_reply_to: [
        /^\s*Reply-To\s?:(.+)$/, # Apple Mail (en)
        /^\s*Odgovori na\s?:(.+)$/, # Apple Mail (hr)
        /^\s*Odpověď na\s?:(.+)$/, # Apple Mail (cs)
        /^\s*Svar til\s?:(.+)$/, # Apple Mail (da)
        /^\s*Antwoord aan\s?:(.+)$/, # Apple Mail (nl)
        /^\s*Vastaus\s?:(.+)$/, # Apple Mail (fi)
        /^\s*Répondre à\s?:(.+)$/, # Apple Mail (fr)
        /^\s*Antwort an\s?:(.+)$/, # Apple Mail (de)
        /^\s*Válaszcím\s?:(.+)$/, # Apple Mail (hu)
        /^\s*Rispondi a\s?:(.+)$/, # Apple Mail (it)
        /^\s*Svar til\s?:(.+)$/, # Apple Mail (no)
        /^\s*Odpowiedź-do\s?:(.+)$/, # Apple Mail (pl)
        /^\s*Responder A\s?:(.+)$/, # Apple Mail (pt)
        /^\s*Responder a\s?:(.+)$/, # Apple Mail (pt-br, es)
        /^\s*Răspuns către\s?:(.+)$/, # Apple Mail (ro)
        /^\s*Ответ-Кому\s?:(.+)$/, # Apple Mail (ru)
        /^\s*Odpovedať-Pre\s?:(.+)$/, # Apple Mail (sk)
        /^\s*Svara till\s?:(.+)$/, # Apple Mail (sv)
        /^\s*Yanıt Adresi\s?:(.+)$/, # Apple Mail (tr)
        /^\s*Кому відповісти\s?:(.+)$/ # Apple Mail (uk)
      ],

      original_cc: [
        /^\*?\s*Cc\s?:\*?(.+)$/, # Apple Mail (en, da, es, fr, hr, it, pt, pt-br, ro, sk), Gmail (all locales), Outlook Live / 365 (all locales), New Outlook 2019 (da, de, en, fr, it, pt-br), Missive (en), HubSpot (de, en, es, it, nl, pt-br)
        /^\s*CC\s?:(.+)$/, # New Outlook 2019 (es, nl, pt), Thunderbird (da, en, es, fi, hr, hu, it, nl, no, pt, pt-br, ro, tr, uk)
        /^\s*Kopie\s?:(.+)$/, # Apple Mail (cs, de, nl), New Outlook 2019 (cs), Thunderbird (cs)
        /^\s*Kopio\s?:(.+)$/, # Apple Mail (fi), New Outlook 2019 (fi), HubSpot (fi)
        /^\s*Másolat\s?:(.+)$/, # Apple Mail (hu)
        /^\s*Kopi\s?:(.+)$/, # Apple Mail (no)
        /^\s*Dw\s?:(.+)$/, # Apple Mail (pl)
        /^\s*Копия\s?:(.+)$/, # Apple Mail (ru), New Outlook 2019 (ru), Thunderbird (ru)
        /^\s*Kopia\s?:(.+)$/, # Apple Mail (sv), New Outlook 2019 (sv), Thunderbird (pl, sv), HubSpot (sv)
        /^\s*Bilgi\s?:(.+)$/, # Apple Mail (tr)
        /^\s*Копія\s?:(.+)$/, # Apple Mail (uk),
        /^\s*Másolatot kap\s?:(.+)$/, # New Outlook 2019 (hu)
        /^\s*Kópia\s?:(.+)$/, # New Outlook 2019 (sk), Thunderbird (sk)
        /^\s*DW\s?:(.+)$/, # New Outlook 2019 (pl), HubSpot (pl)
        /^\s*Kopie \(CC\)\s?:(.+)$/, # Thunderbird (de)
        /^\s*Copie à\s?:(.+)$/, # Thunderbird (fr)
        /^\s*CC：(.+)$/ # HubSpot (ja)
      ],

      original_cc_lax: [
        /\s*Cc\s?:(.+)$/, # Yahoo Mail (da, en, it, nl, pt, pt-br, ro, tr)
        /\s*CC\s?:(.+)$/, # Yahoo Mail (de, es)
        /\s*Kopie\s?:(.+)$/, # Yahoo Mail (cs)
        /\s*Kopio\s?:(.+)$/, # Yahoo Mail (fi)
        /\s*Másolat\s?:(.+)$/, # Yahoo Mail (hu)
        /\s*Kopi\s?:(.+)$/, # Yahoo Mail (no)
        /\s*Dw\s?(.+)$/, # Yahoo Mail (pl)
        /\s*Копия\s?:(.+)$/, # Yahoo Mail (ru)
        /\s*Kópia\s?:(.+)$/, # Yahoo Mail (sk)
        /\s*Kopia\s?:(.+)$/, # Yahoo Mail (sv)
        /\s*Копія\s?:(.+)$/ # Yahoo Mail (uk)
      ],

      original_date: [
        /^\s*Date\s?:(.+)$/, # Apple Mail (en, fr), Gmail (all locales), New Outlook 2019 (en, fr), Thunderbird (da, en, fr), Missive (en), HubSpot (en, fr)
        /^\s*Datum\s?:(.+)$/, # Apple Mail (cs, de, hr, nl, sv), New Outlook 2019 (cs, de, nl, sv), Thunderbird (cs, de, hr, nl, sv), HubSpot (de, nl, sv)
        /^\s*Dato\s?:(.+)$/, # Apple Mail (da, no), New Outlook 2019 (da), Thunderbird (no)
        /^\s*Envoyé\s?:(.+)$/, # New Outlook 2019 (fr)
        /^\s*Fecha\s?:(.+)$/, # Apple Mail (es), New Outlook 2019 (es), Thunderbird (es), HubSpot (es)
        /^\s*Päivämäärä\s?:(.+)$/, # Apple Mail (fi), New Outlook 2019 (fi), HubSpot (fi)
        /^\s*Dátum\s?:(.+)$/, # Apple Mail (hu, sk), New Outlook 2019 (sk), Thunderbird (hu, sk)
        /^\s*Data\s?:(.+)$/, # Apple Mail (it, pl, pt, pt-br), New Outlook 2019 (it, pl, pt, pt-br), Thunderbird (it, pl, pt, pt-br), HubSpot (it, pl, pt-br)
        /^\s*Dată\s?:(.+)$/, # Apple Mail (ro), Thunderbird (ro)
        /^\s*Дата\s?:(.+)$/, # Apple Mail (ru, uk), New Outlook 2019 (ru), Thunderbird (ru, uk)
        /^\s*Tarih\s?:(.+)$/, # Apple Mail (tr), Thunderbird (tr)
        /^\*?\s*Sent\s?:\*?(.+)$/, # Outlook Live / 365 (all locales)
        /^\s*Päiväys\s?:(.+)$/, # Thunderbird (fi)
        /^\s*日付：(.+)$/ # HubSpot (ja)
      ],

      original_date_lax: [
        /\s*Datum\s?:(.+)$/, # Yahoo Mail (cs)
        /\s*Sendt\s?:(.+)$/, # Yahoo Mail (da, no)
        /\s*Gesendet\s?:(.+)$/, # Yahoo Mail (de)
        /\s*Sent\s?:(.+)$/, # Yahoo Mail (en)
        /\s*Enviado\s?:(.+)$/, # Yahoo Mail (es, pt, pt-br)
        /\s*Envoyé\s?:(.+)$/, # Yahoo Mail (fr)
        /\s*Lähetetty\s?:(.+)$/, # Yahoo Mail (fi)
        /\s*Elküldve\s?:(.+)$/, # Yahoo Mail (hu)
        /\s*Inviato\s?:(.+)$/, # Yahoo Mail (it)
        /\s*Verzonden\s?:(.+)$/, # Yahoo Mail (it)
        /\s*Wysłano\s?:(.+)$/, # Yahoo Mail (pl)
        /\s*Trimis\s?:(.+)$/, # Yahoo Mail (ro)
        /\s*Отправлено\s?:(.+)$/, # Yahoo Mail (ru)
        /\s*Odoslané\s?:(.+)$/, # Yahoo Mail (sk)
        /\s*Skickat\s?:(.+)$/, # Yahoo Mail (sv)
        /\s*Gönderilen\s?:(.+)$/, # Yahoo Mail (tr)
        /\s*Відправлено\s?:(.+)$/ # Yahoo Mail (uk)
      ],

      mailbox: [
        /^\s?\n?\s*<.+?<mailto:(.+?)>>/, # "<walter.sheltan@acme.com<mailto:walter.sheltan@acme.com>>"
        /^(.+?)\s?\n?\s*<.+?<mailto:(.+?)>>/, # "Walter Sheltan <walter.sheltan@acme.com<mailto:walter.sheltan@acme.com>>"
        /^(.+?)\s?\n?\s*[\[|<]mailto:(.+?)[\]|>]/, # "Walter Sheltan <mailto:walter.sheltan@acme.com>" or "Walter Sheltan [mailto:walter.sheltan@acme.com]" or "walter.sheltan@acme.com <mailto:walter.sheltan@acme.com>"
        /^'(.+?)'\s?\n?\s*[\[|<](.+?)[\]|>]/, # "'Walter Sheltan' <walter.sheltan@acme.com>" or "'Walter Sheltan' [walter.sheltan@acme.com]" or "'walter.sheltan@acme.com' <walter.sheltan@acme.com>"
        /^"'(.+?)'"\s?\n?\s*[\[|<](.+?)[\]|>]/, # ""'Walter Sheltan'" <walter.sheltan@acme.com>" or ""'Walter Sheltan'" [walter.sheltan@acme.com]" or ""'walter.sheltan@acme.com'" <walter.sheltan@acme.com>"
        /^"(.+?)"\s?\n?\s*[\[|<](.+?)[\]|>]/, # ""Walter Sheltan" <walter.sheltan@acme.com>" or ""Walter Sheltan" [walter.sheltan@acme.com]" or ""walter.sheltan@acme.com" <walter.sheltan@acme.com>"
        /^([^,;]+?)\s?\n?\s*[\[|<](.+?)[\]|>]/, # "Walter Sheltan <walter.sheltan@acme.com>" or "Walter Sheltan [walter.sheltan@acme.com]" or "walter.sheltan@acme.com <walter.sheltan@acme.com>"
        /^(.?)\s?\n?\s*[\[|<](.+?)[\]|>]/, # "<walter.sheltan@acme.com>"
        /^([^\s@]+@[^\s@]+\.[^\s@,]+)/, # "walter.sheltan@acme.com"
        /^([^;].+?)\s?\n?\s*[\[|<](.+?)[\]|>]/ # "Walter, Sheltan <walter.sheltan@acme.com>" or "Walter, Sheltan [walter.sheltan@acme.com]"
      ],

      mailbox_address: [
        /^(([^\s@]+)@([^\s@]+)\.([^\s@]+))$/
      ]
    }.freeze

    def initialize
      @regexes = load_regexes
    end

    def parse_subject(subject)
      match = Utils.loop_regexes(@regexes[:subject], subject)

      if match && match.length > 1
        # Notice: return an empty string if the detected subject is empty
        # (e.g. 'Fwd: ')
        return Utils.trim_string(match[1]).to_s
      end

      nil
    end

    def parse_body(body, forwarded = false)
      # Replace carriage return with regular line break
      body = body.gsub(@regexes[:carriage_return], "\n")

      # Remove Byte Order Mark
      body.gsub!(@regexes[:byte_order_mark], "")

      # Remove trailing Non-breaking space
      body.gsub!(@regexes[:trailing_non_breaking_space], "")

      # Replace Non-breaking space with regular space
      body.gsub!(@regexes[:non_breaking_space], " ")

      # First method: split via the separator (Apple Mail, Gmail,
      # Outlook Live / 365, Outlook 2019, Yahoo Mail, Thunderbird)
      # Notice: use 'line' regex that will capture the line itself, as we may
      # need it to build the original email back (in case of nested emails)
      match = Utils.loop_regexes(@regexes[:separator_line], body, "split")

      if match && match.length > 2
        # The `split` operation creates a match with 3 substrings:
        #  * 0: anything before the line with the separator (i.e. the message)
        #  * 1: the line with the separator
        #  * 2: anything after the line with the separator (i.e. the body of
        #       the original email)
        # Notice: in case of nested emails, there may be several matches
        # against 'separator_line'. In that case, the `split` operation
        # creates a match with (n x 3) substrings. We need to reconciliate
        # those substrings.
        email = Utils.reconciliate_split_match(
          match,
          3, # min_substrings
          [2] # default_substrings (By default, attach anything after the line with the separator)
        )

        return {
          body: body,
          message: Utils.trim_string(match[0]),
          email: Utils.trim_string(email)
        }
      end

      # Attempt second method?
      # Notice: as this second method is more uncertain (we split via the From
      # part, without further verification), we have to be sure we can
      # attempt it. The `forwarded` boolean gives the confirmation that the
      # email was indeed forwarded (detected from the Subject part)
      if forwarded == true
        # Second method: split via the From part (New Outlook 2019,
        # Outlook Live / 365)
        match = Utils.loop_regexes(@regexes[:original_from], body, "split")

        if match && match.length > 3
          # The `split` operation creates a match with 4 substrings:
          #  * 0: anything before the line with the From part (i.e. the
          #       message before the original email)
          #  * 1: the line with the From part (in the original email)
          #  * 2: the From part itself
          #  * 3: anything after the line with the From part (i.e.
          #       the rest of the original email)
          # Notice: in case of nested emails, there may be several matches
          # against 'original_from'. In that case, the `split` operation
          # creates a match with (n x 4) substrings. We need to reconciliate
          # those substrings.
          email = Utils.reconciliate_split_match(
            match,
            4, # min_substrings
            [1, 3], # default_substrings (By default, attach the line that contains the From part back to the rest of the original email (exclude the From part itself))
            lambda { |i|
              i % 3 == 2
            } # fn_exclude (When reconciliating other substrings, we want to exclude the From part itself)
          )

          return {
            body: body,
            message: Utils.trim_string(match[0]),
            email: Utils.trim_string(email)
          }
        end
      end

      {}
    end

    def parse_original_email(text, body)
      # Remove Byte Order Mark
      text = text.gsub(@regexes[:byte_order_mark], "")

      # Remove ">" at the beginning of each line, while keeping line breaks
      text = text.gsub(@regexes[:quote_line_break], "")

      # Remove ">" at the beginning of other lines
      text = text.gsub(@regexes[:quote], "")

      # Remove "    " at the beginning of lines
      text = text.gsub(@regexes[:four_spaces], "")

      {
        body: parse_original_body(text),
        from: parse_original_from(text, body),
        to: parse_original_to(text),
        cc: parse_original_cc(text),
        subject: parse_original_subject(text),
        date: parse_original_date(text, body)
      }
    end

    private

    def load_regexes
      @regexes = {}
      REGEXES.each do |key, entry|
        key_line = "#{key}_line".to_sym
        if entry.is_a?(Array)
          @regexes[key] = []
          @regexes[key_line] = []

          entry.each do |regex|
            # Build 'line' alternative?
            if LINE_REGEXES.include?(key)
              regex_line = build_line_regex(regex)
              @regexes[key_line] << regex_line
            end

            @regexes[key] << Regexp.new(regex)
          end
        else
          regex = entry

          # Build 'line' alternative?
          if LINE_REGEXES.include?(key)
            regex_line = build_line_regex(regex)
            @regexes[key_line] = regex_line
          end

          @regexes[key] = Regexp.new(regex)
        end
      end
      @regexes
    end

    # Builds 'line' alternative regex
    # @param regex [Regexp] The regular expression to build a line regex from
    # @return [Regexp] The 'line' regex
    def build_line_regex(regex)
      # A 'line' regex will capture not only inner groups, but also the line itself
      # Important: `regex` must be a Regexp object, not a string
      source = "(#{regex.source})"
      flags = 0
      flags |= Regexp::IGNORECASE if regex.options & Regexp::IGNORECASE != 0
      flags |= Regexp::MULTILINE if regex.options & Regexp::MULTILINE != 0
      flags |= Regexp::EXTENDED if regex.options & Regexp::EXTENDED != 0

      Regexp.new(source, flags)
    end

    def parse_original_body(text)
      match = nil

      # First method: extract the text after the Subject part
      # (Outlook Live / 365) or after the Cc, To or Reply-To part
      # (Apple Mail, Gmail) or Date part (MailMate). A new line must be
      # present.
      # Notice: use 'line' regexes that will capture not only the Subject, Cc,
      # To or Reply-To part, but also the line itself, as we may need it
      # to build the original body back (in case of nested emails)
      regexes = [
        @regexes[:original_subject_line],
        @regexes[:original_cc_line],
        @regexes[:original_to_line],
        @regexes[:original_reply_to_line],
        @regexes[:original_date_line]
      ]

      regexes.each do |regex|
        match = Utils.loop_regexes(regex, text, "split")

        # A new line must be present between the Cc, To, Reply-To or Subject
        # part and the actual body
        next unless match && match.length > 2 && match[3]&.start_with?("\n\n")

        # The `split` operation creates a match with 4 substrings:
        #  * 0: anything before the line with the Subject, Cc, To or Reply-To
        #       part
        #  * 1: the line with the Subject, Cc, To or Reply-To part
        #  * 2: the Subject, Cc, To or Reply-To part itself
        #  * 3: anything after the line with the Subject, Cc, To or Reply-To
        #       part (i.e. the body of the original email)
        # Notice: in case of nested emails, there may be several matches
        # against 'original_subject_line', 'original_cc_line',
        # 'original_to_line' or 'original_reply_to_line'. In that case, the
        # `split` operation creates a match with (n x 4) substrings. We
        # need to reconciliate those substrings.
        body = Utils.reconciliate_split_match(
          match,
          4,
          [3],
          ->(i) { i % 3 == 2 }
        )

        return Utils.trim_string(body)
      end

      # Second method: extract the text after the Subject part
      # (New Outlook 2019, Yahoo Mail). No new line must be present.
      # Notice: use 'line' regexes that will capture not only the Subject part,
      # but also the line itself, as we may need it to build the original
      # body back (in case of nested emails)
      match = Utils.loop_regexes(
        @regexes[:original_subject_line] + @regexes[:original_subject_lax_line],
        text,
        "split"
      )

      # Do not bother checking for new line between the Subject part and the
      # actual body (specificity of New Outlook 2019 and Yahoo Mail)
      if match && match.length > 3
        # The `split` operation creates a match with 4 substrings:
        #  * 0: anything before the line with the Subject part
        #  * 1: the line with the Subject part (in the original email)
        #  * 2: the Subject part itself
        #  * 3: anything after the line with the Subject part (i.e. the body of
        #       the original email)
        # Notice: in case of nested emails, there may be several matches
        # against 'original_subject_line' and 'original_subject_lax_line'. In
        # that case, the `split` operation creates a match with (n x 4)
        # substrings. We need to reconciliate those substrings.
        body = Utils.reconciliate_split_match(
          match,
          4,
          [3],
          ->(i) { i % 3 == 2 }
        )

        return Utils.trim_string(body)
      end

      # Third method: return the raw text, as there is no original information
      # embedded (no Cc, To, Subject, etc.) (Outlook 2019)
      text
    end

    # Parses mailboxes(s)
    # @private
    # @param regexes [Array<Regexp>] Array of regular expressions to match mailboxes
    # @param text [String] The text to parse
    # @param force_array [Boolean] Whether to force the return value to be an array
    # @return [Array<Hash>, Hash, nil] The parsed mailbox(es) or nil if not found
    def parse_mailbox(regexes, text, force_array = false)
      match = Utils.loop_regexes(regexes, text)
      if match&.length&.positive?
        mailboxes_line = Utils.trim_string(match[-1])

        if mailboxes_line
          mailboxes = []

          while mailboxes_line
            mailbox_match = Utils.loop_regexes(@regexes[:mailbox], mailboxes_line)

            # Address and / or name available?
            if mailbox_match&.length&.positive?
              address = nil
              name = nil

              # Address and name available?
              if mailbox_match.length == 3
                address = mailbox_match[2]
                name = mailbox_match[1]
              else
                address = mailbox_match[1]
              end

              mailboxes << prepare_mailbox(address, name)

              # Remove matched mailbox from mailboxes line
              mailboxes_line = Utils.trim_string(
                mailboxes_line.sub(mailbox_match[0], "")
              )

              if mailboxes_line
                # Remove leading mailboxes separator
                MAILBOXES_SEPARATORS.each do |separator|
                  if mailboxes_line[0] == separator
                    mailboxes_line = Utils.trim_string(mailboxes_line[1..])
                    break
                  end
                end
              end
            else
              mailboxes << prepare_mailbox(mailboxes_line, nil)

              # No more matches
              mailboxes_line = nil
            end
          end

          # Return multiple mailboxes
          return mailboxes if mailboxes.length > 1

          # Return single mailbox
          return force_array ? mailboxes : mailboxes[0]
        end
      end

      # No mailbox found
      force_array ? [] : nil
    end

    # Parses the author (From)
    # @private
    # @param text [String]
    # @param body [String]
    # @return [Hash] The parsed author
    def parse_original_from(text, body)
      address = nil
      name = nil

      # First method: extract the author via the From part (Apple Mail, Gmail,
      # Outlook Live / 365, New Outlook 2019, Thunderbird)
      author = parse_mailbox(@regexes[:original_from], text)

      # Author found?
      return author if author.is_a?(Hash) && (author&.dig(:address) || author&.dig(:name))

      # Multiple authors found?
      return author.first if author.is_a?(Array) && (author[0][:address] || author[0][:name])

      # Second method: extract the author via the separator (Outlook 2019)
      match = Utils.loop_regexes(@regexes[:separator_with_information], body)

      if match && match.length == 4 && match.is_a?(MatchData)
        # Notice: the order of parts may change depending on the localization,
        # hence the use of named captures
        address = match[:from_address]
        name = match[:from_name]

        return prepare_mailbox(address, name)
      end

      # Third method: extract the author via the From part, using lax regexes
      # (Yahoo Mail)
      match = Utils.loop_regexes(@regexes[:original_from_lax], text)

      if match && match.length > 1
        address = match[3]
        name = match[2]

        return prepare_mailbox(address, name)
      end

      prepare_mailbox(address, name)
    end

    # Parses the subject part
    # @private
    # @param text [String]
    # @return [String, nil] The parsed subject or nil if not found
    def parse_original_subject(text)
      # First method: extract the subject via the Subject part (Apple Mail,
      # Gmail, Outlook Live / 365, New Outlook 2019, Thunderbird)
      match = Utils.loop_regexes(@regexes[:original_subject], text)

      return Utils.trim_string(match[1]) if match&.length&.positive?

      # Second method: extract the subject via the Subject part, using lax
      # regexes (Yahoo Mail)
      match = Utils.loop_regexes(@regexes[:original_subject_lax], text)

      return Utils.trim_string(match[1]) if match&.length&.positive?

      nil
    end

    # Parses the primary recipient(s) (To)
    # @private
    # @param text [String]
    # @return [Array<Hash>] The parsed primary recipient(s)
    def parse_original_to(text)
      # First method: extract the primary recipient(s) via the To part
      # (Apple Mail, Gmail, Outlook Live / 365, New Outlook 2019, Thunderbird)
      recipients = parse_mailbox(
        @regexes[:original_to],
        text,
        force_array: true
      )

      # Recipient(s) found?
      return recipients if recipients.is_a?(Array) && recipients.any?

      # Second method: the Subject, Date and Cc parts are stuck to the To part,
      # remove them before attempting a new extract, using lax regexes
      # (Yahoo Mail)
      clean_text = Utils.loop_regexes(
        @regexes[:original_subject_lax],
        text,
        "replace"
      )

      clean_text = Utils.loop_regexes(
        @regexes[:original_date_lax],
        clean_text,
        "replace"
      )

      clean_text = Utils.loop_regexes(
        @regexes[:original_cc_lax],
        clean_text,
        "replace"
      )

      parse_mailbox(
        @regexes[:original_to_lax],
        clean_text,
        force_array: true
      )
    end

    def parse_original_cc(text)
      # First method: extract the carbon-copy recipient(s) via the Cc part
      # (Apple Mail, Gmail, Outlook Live / 365, New Outlook 2019, Thunderbird)
      recipients = parse_mailbox(
        @regexes[:original_cc],
        text,
        force_array: true
      )

      # Recipient(s) found?
      return recipients if recipients.is_a?(Array) && recipients.any?

      # Second method: the Subject and Date parts are stuck to the To part,
      # remove them before attempting a new extract, using lax regexes
      # (Yahoo Mail)
      clean_text = Utils.loop_regexes(
        @regexes[:original_subject_lax],
        text,
        "replace"
      )

      clean_text = Utils.loop_regexes(
        @regexes[:original_date_lax],
        clean_text,
        "replace"
      )

      parse_mailbox(
        @regexes[:original_cc_lax],
        clean_text,
        force_array: true
      )
    end

    def parse_original_date(text, body)
      # First method: extract the date via the Date part (Apple Mail, Gmail,
      # Outlook Live / 365, New Outlook 2019, Thunderbird)
      match = Utils.loop_regexes(@regexes[:original_date], text)

      return Utils.trim_string(match[1]) if match&.length&.positive?

      # Second method: extract the date via the separator (Outlook 2019)
      match = Utils.loop_regexes(@regexes[:separator_with_information], body)

      if match && match.length == 4 && match.is_a?(MatchData)
        # Notice: the order of parts may change depending on the localization,
        # hence the use of named captures
        return Utils.trim_string(match[:date])
      end

      # Third method: the Subject part is stuck to the Date part, remove it
      # before attempting a new extract, using lax regexes (Yahoo Mail)
      clean_text = Utils.loop_regexes(
        @regexes[:original_subject_lax],
        text,
        "replace"
      )

      match = Utils.loop_regexes(@regexes[:original_date_lax], clean_text)

      return Utils.trim_string(match[1]) if match&.length&.positive?

      nil
    end

    # Prepares mailbox
    # @private
    # @param address [String]
    # @param name [String]
    # @return [Hash] The prepared mailbox
    def prepare_mailbox(address, name)
      address = Utils.trim_string(address)
      name = Utils.trim_string(name)

      # Make sure mailbox address is valid
      mailbox_address_match = Utils.loop_regexes(
        @regexes[:mailbox_address],
        address
      )

      # Invalid mailbox address? Some clients only include the name
      if mailbox_address_match.nil?
        name = address
        address = nil
      end

      address = address.empty? || address.empty? ? nil : address
      name = name.empty? ? nil : name

      {
        address: (address.nil? || address.empty? ? nil : address),

        # Some clients fill the name with the address
        # ("bessie.berry@acme.com <bessie.berry@acme.com>")
        name: address != name ? name : nil
      }
    end
  end
end
