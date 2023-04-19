require 'rails_helper'

RSpec.describe InternalNotificationJob, type: :job do
  let(:response) { create(:response) }

  describe "#perform" do
    it "calls InternalNotificationOperation" do
      expect(InternalNotificationOperation).to receive(:call).with(response_id: response.id)
      described_class.perform_now(response_id: response.id)
    end
  end
end
