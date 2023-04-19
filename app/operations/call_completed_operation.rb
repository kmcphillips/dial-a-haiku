# frozen_string_literal: true
class CallCompletedOperation < ApplicationOperation
  input :phone_call_id, accepts: Integer, type: :keyword, required: true

  def execute
    haikus = phone_call.responses.prompt(:gather_inspiration).map(&:haiku).reject(&:blank?)

    if haikus.any?
      Twilio::Rails::SMS::SendOperation.call(
        phone_caller_id: phone_call.phone_caller.id,
        messages: haikus,
        from_number: Twilio::Rails.config.default_outgoing_phone_number
      )
    end
  end

  private

  def phone_call
    @phone_call = PhoneCall.find(phone_call_id)
  end
end
