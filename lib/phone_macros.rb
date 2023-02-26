# frozen_string_literal: true
module PhoneMacros
  def last_completed_haiku(response)
    response.phone_call.responses.prompt(:gather_inspiration).last.haiku_formatted_for_voice
  end

  def last_responses_all(response, prompt:, count:)
    responses = response.phone_call.responses.last(count)
    return false if responses.count < count
    responses.all?{ |r| r.prompt_handle == prompt.to_s }
  end
end
