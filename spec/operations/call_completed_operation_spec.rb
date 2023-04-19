# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CallCompletedOperation, type: :operation do
  let(:phone_call) { create(:phone_call, tree_name: "haiku") }
  let(:response) { create(:response, :transcribed, prompt_handle: "gather_inspiration", phone_call: phone_call, haiku: haiku) }
  let(:haiku) { "this is a test line\nand another testing line\nfinish with a third" }

  describe "#execute" do
    it "does not send a notification if there are no haikus" do
      expect(Twilio::Rails::SMS::SendOperation).to_not receive(:call)
      described_class.call(phone_call_id: phone_call.id)
    end

    it "sends a notification if there is a haiku" do
      response
      expect(Twilio::Rails::SMS::SendOperation).to receive(:call).with(
        phone_caller_id: phone_call.phone_caller.id,
        messages: [ haiku ],
        from_number: Twilio::Rails.config.default_outgoing_phone_number
      )
      described_class.call(phone_call_id: phone_call.id)
    end
  end
end
