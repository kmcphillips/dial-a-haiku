# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Response, type: :model do
  let(:phone_call) { create(:phone_call, tree_name: "haiku") }
  let(:response) { create(:response, prompt_handle: "gather_inspiration", phone_call: phone_call) }
  let(:haiku) { "this is a test line\nand another testing line\nfinish with a third\n" }

  context "callbacks" do
    it "enqueues if the correct prompt and tree and there is a change to the transcription" do
      expect {
        response.transcription = "a pickle"
        response.save!
      }.to have_enqueued_job(GenerateHaikuJob)
    end

    it "does not enqueue if transcription is blank" do
      expect {
        response.transcription = ""
        response.save!
      }.to_not have_enqueued_job(GenerateHaikuJob)
    end

    it "does not enqueue if a different prompt" do
      response.update!(prompt_handle: "something_else")
      expect {
        response.transcription = "a pickle"
        response.save!
      }.to_not have_enqueued_job(GenerateHaikuJob)
    end
  end

  describe "#haiku_lines" do
    it "returns nil if there is no haiku" do
      expect(response.haiku_lines).to be_nil
    end

    it "splits the string into lines" do
      response.update!(haiku: haiku)
      expect(response.haiku_lines).to eq([
        "this is a test line",
        "and another testing line",
        "finish with a third",
      ])
    end
  end

  describe "#haiku_formatted_for_voice" do
    it "returns nil if there is no haiku" do
      expect(response.haiku_formatted_for_voice).to be_nil
    end

    it "adds a period and concats into one line" do
      response.update!(haiku: haiku)
      expect(response.haiku_formatted_for_voice).to eq("this is a test line. and another testing line. finish with a third.")
    end

    it "scrubs and handles whitespace and punctuation" do
      response.update!(haiku: " hello?\n\ntest!\ntest\n ")
      expect(response.haiku_formatted_for_voice).to eq("hello? test! test.")
    end
  end
end
