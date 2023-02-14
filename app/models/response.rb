# frozen_string_literal: true
class Response < ApplicationRecord
  include Twilio::Rails::Models::Response

  after_update :make_ai_call_callback

  private

  def make_ai_call_callback
    if saved_change_to_transcription? && transcription.present?
      AiCallJob.perform_later(response_id: id)
    end

    true
  end
end
