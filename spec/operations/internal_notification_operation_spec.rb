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
        allow(ENV).to receive(:[]).with("http_proxy").and_return("")
      end

      it "sends a notification if there is a haiku and auth set to ENV" do
        stub_request(:post, "http://example.com/notify").
          with(
            body: "message=%F0%9F%93%96+Dial-a-Haiku+from+**%28613%29+555+1234**%3A%0A*this+is+a+test+line%0Aand+another+testing+line%0Afinish+with+a+third*",
            headers: {
              'Authorization'=>'Basic dGVzdF91c2VybmFtZTp0ZXN0X3Bhc3N3b3Jk',
            }
          ).to_return(status: 200, body: "", headers: {})

        described_class.call(response_id: response.id)
      end
    end

    it "does not send a notification if there is no auth set to ENV" do
      expect_any_instance_of(Faraday::Connection).to_not receive(:post)
      described_class.call(response_id: response.id)
    end
  end
end
