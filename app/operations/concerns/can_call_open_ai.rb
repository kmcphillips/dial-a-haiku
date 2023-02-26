# frozen_string_literal: true
module CanCallOpenAi
  extend ActiveSupport::Concern

  def openai_client
    raise "OPENAI_ACCESS_TOKEN environment variable not set" unless ENV["OPENAI_ACCESS_TOKEN"].present?
    OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])
  end
end
