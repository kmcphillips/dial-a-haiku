require 'rails_helper'

RSpec.describe GenerateHaikuJob, type: :job do
  let(:response) { create(:response) }

  describe "#perform" do
    it "calls GenerateHaikuOperation" do
      expect(GenerateHaikuOperation).to receive(:call).with(response_id: response.id)
      described_class.perform_now(response_id: response.id)
    end
  end
end
