# frozen_string_literal: true
class CallCompletedJob < ApplicationJob
  queue_as :default

  def perform(phone_call_id:)
    CallCompletedOperation.call(phone_call_id: phone_call_id)
  end
end
