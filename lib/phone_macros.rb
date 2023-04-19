# frozen_string_literal: true
module PhoneMacros
  def last_completed_haiku(response)
    response.phone_call.responses.in_order.prompt(:gather_inspiration).last.haiku_formatted_for_voice
  end

  def last_responses_all(response, prompt:, count:)
    responses = response.phone_call.responses.in_order.last(count)
    return false if responses.count < count
    responses.all?{ |r| r.prompt_handle == prompt.to_s }
  end

  def say_faster(text)
    say { |s| s.prosody(words: text, rate: "120%") }
  end
end
