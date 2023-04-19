# frozen_string_literal: true
require 'rails_helper'

RSpec.describe InternalNotificationOperation, type: :operation do
  let(:phone_call) { create(:phone_call, tree_name: "haiku") }
  let(:response) { create(:response, :transcribed, prompt_handle: "gather_inspiration", phone_call: phone_call, haiku: haiku) }
  let(:haiku) { "this is a test line\nand another testing line\nfinish with a third" }

  describe "#execute" do
    context "with ENV set" do
      before do
        allow(ENV).to receive(:[]).with("INTERNAL_NOTIFICATION_URL").and_return("http://example.com/notify")
        allow(ENV).to receive(:[]).with("INTERNAL_NOTIFICATION_USERNAME").and_return("test_username")
        allow(ENV).to receive(:[]).with("INTERNAL_NOTIFICATION_PASSWORD").and_return("test_password")
      end

      it "sends a notification if there is a haiku and auth set to ENV" do
        stub_request(:post, "http://example.com/notify").
          with(
            body: "message=Dial-a-Haiku%3A%0A%2Athis%20is%20a%20test%20line%0Aand%20another%20testing%20line%0Afinish%20with%20a%20third%2A",
            headers: {
              'Authorization'=>'Basic dGVzdF91c2VybmFtZTp0ZXN0X3Bhc3N3b3Jk',
            }
          ).to_return(status: 200, body: "", headers: {})

        described_class.call(response_id: response.id)
      end
    end

    it "does not send a notification if there is no auth set to ENV" do
      expect(HTTParty).to_not receive(:post)
      described_class.call(response_id: response.id)
    end
  end
end
