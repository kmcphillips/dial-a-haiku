# frozen_string_literal: true
class HaikuResponder < Twilio::Rails::SMS::DelegatedResponder
  def handle?
    true
  end

  def reply
    if first_message?
      "Thank you for your text\nBut you must phone and not text\nTo dial-a-haiku"
    else
      "Texting will not work\nYou must dial your phone and talk\nOr else no haiku"
    end
  end

  private

  def first_message?
    phone_caller.sms_conversations.one? && sms_conversation.messages.inbound.one?
  end
end
