# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PhoneMacros do
  let(:phone_call) { create(:phone_call, tree_name: "haiku") }
  let(:response) { create(:response, prompt_handle: "gather_inspiration", phone_call: phone_call) }
  subject(:macros) {
    Twilio::Rails::Phone::TreeMacros.include(PhoneMacros)
  }

  describe "#last_completed_haiku" do
    it "returns nil if there is no haiku" do
      expect(macros.last_completed_haiku(response)).to be_nil
    end

    it "finds the haiku" do
      response.update!(haiku: "hello?\n\ntest!\ntest\n")
      expect(macros.last_completed_haiku(response)).to eq("hello? test! test.")
    end
  end

  describe "#last_responses_all" do
    it "returns false if they are not all the same prompt" do
      create(:response, phone_call: phone_call, prompt_handle: "gather_inspiration")
      create(:response, phone_call: phone_call, prompt_handle: "pickle")
      create(:response, phone_call: phone_call, prompt_handle: "gather_inspiration")
      expect(macros.last_responses_all(response, prompt: :gather_inspiration, count: 3)).to be_falsy
    end

    it "returns false if there are not enough prompts" do
      create(:response, phone_call: phone_call, prompt_handle: "gather_inspiration")
      expect(macros.last_responses_all(response, prompt: :gather_inspiration, count: 3)).to be_falsy
    end

    it "returns true if they are all the same prompt" do
      create(:response, phone_call: phone_call, prompt_handle: "gather_inspiration")
      create(:response, phone_call: phone_call, prompt_handle: "gather_inspiration")
      create(:response, phone_call: phone_call, prompt_handle: "gather_inspiration")
      expect(macros.last_responses_all(response, prompt: :gather_inspiration, count: 3)).to be_truthy
    end
  end

  describe "#say_faster" do
    it "says the text faster with SSML" do
      expect(macros.say_faster("hello")).to be_a(Twilio::Rails::Phone::Tree::Message)
    end
  end
end
