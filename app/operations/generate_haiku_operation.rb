# frozen_string_literal: true
class GenerateHaikuOperation < ApplicationOperation
  input :response_id, accepts: Integer, type: :keyword, required: true

  ATTEMPTS = 3
  include CanCallOpenAi

  def execute
    raise "Expected :haiku :gather_inspiration but got #{ response.inspect }" unless response.is?(tree: :haiku, prompt: :gather_inspiration)
    raise "Cannot process response with no transcription #{ response.inspect }" unless response.transcription.present?

    haiku_response = nil

    ATTEMPTS.times do
      openai_response = openai_client.chat(
        parameters: {
          messages: [
            { role: "user", content: prompt }
          ],
          model: "gpt-4o",
          temperature: 0.7,
          max_tokens: 80,
        }
      )

      if !openai_response.key?("error")
        haiku_response = format_haiku(openai_response["choices"][0]["message"]["content"])
        break if valid_looking_haiku?(haiku_response)
      else
        Rails.logger.error("OpenAI request was not successful #{ openai_response }")
      end
    end

    if haiku_response.present?
      Rails.logger.warn("OpenAI returned invalid haikus after #{ ATTEMPTS } but we're going to use it anyway #{ haiku_response }") unless valid_looking_haiku?(haiku_response)
      response.update!(haiku: haiku_response)
      InternalNotificationJob.perform_later(response_id: response.id)

      response
    else
      raise "Could not get a valid haiku after #{ ATTEMPTS } attempts"
    end
  end

  private

  def response
    @response ||= Response.find(response_id)
  end

  def valid_looking_haiku?(haiku)
    haiku.present? && haiku.lines.map(&:strip).reject(&:blank?).size == 3
  end

  def format_haiku(haiku)
    (haiku.presence || "").lines.map(&:strip).reject(&:blank?).join("\n")
  end

  def prompt
    "Write a haiku about #{ response.transcription }"
  end
end
