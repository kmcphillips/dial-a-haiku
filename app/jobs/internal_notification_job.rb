# frozen_string_literal: true
class InternalNotificationJob < ApplicationJob
  queue_as :default

  def perform(response_id:)
    InternalNotificationOperation.call(response_id: response_id)
  end
end
