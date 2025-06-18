# frozen_string_literal: true
require 'rails_helper'

RSpec.describe GenerateHaikuOperation, type: :operation do
  let(:phone_call) { create(:phone_call, tree_name: "haiku") }
  let(:response) { create(:response, :transcribed, prompt_handle: "gather_inspiration", phone_call: phone_call) }
  let(:haiku) { "this is a test line\nand another testing line\nfinish with a third" }

  def stub_openai_requests(prompt:, response:)
    stub_request(:post, "https://api.openai.com/v1/chat/completions").
      with(
        body: "{\"messages\":[{\"role\":\"user\",\"content\":\"Write a haiku about #{prompt}\"}],\"model\":\"gpt-4o\",\"temperature\":0.7,\"max_tokens\":80}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby'
        }
      ).to_return(
        Array(response).map { |r|
          if r.is_a?(Hash)
            r
          elsif r.is_a?(String)
            {
              status: 200,
              headers: { 'Content-Type'=>'application/json' },
              body: { choices: [ { message: { content: r } } ] }.to_json
            }
          else
            raise "Invalid response type: #{ r.class }"
          end
        }
      )
  end

  describe "#execute" do
    fit "sets the haiku on the AI response" do
      stub_openai_requests(prompt: response.transcription, response: haiku)
      GenerateHaikuOperation.call(response_id: response.id)
      expect(response.reload.haiku).to eq(haiku)
    end

    it "sets the second haiku if it is valid" do
      stub_openai_requests(prompt: response.transcription, response: [ "invalid", haiku ])
      GenerateHaikuOperation.call(response_id: response.id)
      expect(response.reload.haiku).to eq(haiku)
    end

    it "it sets the haiku on the third response" do
      stub_openai_requests(prompt: response.transcription, response: [ "invalid 1", "invalid 2", haiku ])
      GenerateHaikuOperation.call(response_id: response.id)
      expect(response.reload.haiku).to eq(haiku)
    end

    it "allows an invalid haiku to be selected if three invalid are returned" do
      stub_openai_requests(prompt: response.transcription, response: [ "invalid 1", "invalid 2", "invalid 3" ])
      GenerateHaikuOperation.call(response_id: response.id)
      expect(response.reload.haiku).to eq("invalid 3")
    end

    it "allows a couple error respones and retries" do
      invalid_response = {
        status: 500,
        headers: { 'Content-Type'=>'application/json' },
        body: "{\"error\": \"Server Error\"}"
      }
      stub_openai_requests(prompt: response.transcription, response: [ invalid_response, invalid_response, haiku ])
      GenerateHaikuOperation.call(response_id: response.id)
      expect(response.reload.haiku).to eq(haiku)
    end

    it "raises if no haiku is returned" do
      stub_openai_requests(prompt: response.transcription, response: "")
      expect { GenerateHaikuOperation.call(response_id: response.id) }.to raise_error(StandardError)
    end

    it "raises if not the right response" do
      response.update!(prompt_handle: "something_else")
      expect { GenerateHaikuOperation.call(response_id: response.id) }.to raise_error(StandardError)
    end

    it "raises if no transcription" do
      response.update!(transcription: nil)
      expect { GenerateHaikuOperation.call(response_id: response.id) }.to raise_error(StandardError)
    end
  end
end
