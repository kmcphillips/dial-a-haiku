# frozen_string_literal: true
class GenerateHaikuJob < ApplicationJob
  queue_as :default

  def perform(response_id:)
    GenerateHaikuOperation.call(response_id: response_id)
  end
end
