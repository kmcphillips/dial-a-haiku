require 'rails_helper'

RSpec.describe CallCompletedJob, type: :job do
  let(:phone_call) { create(:phone_call) }

  describe "#perform" do
    it "calls CallCompletedOperation" do
      expect(CallCompletedOperation).to receive(:call).with(phone_call_id: phone_call.id)
      described_class.perform_now(phone_call_id: phone_call.id)
    end
  end
end
