# frozen_string_literal: true
class InternalNotificationOperation < ApplicationOperation
  input :response_id, accepts: Integer, type: :keyword, required: true

  def execute
    if response.haiku.present? && url.present? && username.present? && password.present?
      HTTParty.post(url,
        basic_auth: {
          username: username,
          password: password,
        },
        body: {
          message: "📖 Dial-a-Haiku from **#{ Twilio::Rails::Formatter.display_phone_number(response.phone_call.from_number) }**:\n*#{ response.haiku }*",
        }
      )
    end
  end

  private

  def url
    ENV["INTERNAL_NOTIFICATION_URL"]
  end

  def username
    ENV["INTERNAL_NOTIFICATION_USERNAME"]
  end

  def password
    ENV["INTERNAL_NOTIFICATION_PASSWORD"]
  end

  def response
    @response ||= Response.find(response_id)
  end
end
