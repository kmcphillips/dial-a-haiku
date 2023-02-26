# frozen_string_literal: true
class Response < ApplicationRecord
  include Twilio::Rails::Models::Response

  after_update :enqueue_generate_haiku_job_callback

  def haiku_lines
    return nil unless haiku.present?
    haiku.lines.map(&:strip).reject(&:blank?)
  end

  private

  def enqueue_generate_haiku_job_callback
    GenerateHaikuJob.perform_later(response_id: id) if is?(tree: :haiku_tree, prompt: :gather_inspiration) &&
      saved_change_to_transcription? && transcription.present?
    true
  end
end
