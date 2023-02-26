# frozen_string_literal: true
class HaikuTree < Twilio::Rails::Phone::BaseTree
  voice "Polly.Joanna-Neural"

  final_timeout_message("You seem to be gone. I'm sorry to have lost you. Please call again soon.")
  invalid_phone_number("I'm sorry, but you must phone from a valid north american phone number. Goodbye.")

  greeting message: macros.play_public_file("chimes.wav"),
    prompt: :hello

  prompt :hello,
    message: ->(response) {
      if response.phone_caller.inbound_calls_for(tree_name).count <= 1
        "Hello! Thank you for calling Dial-a-Haiku."
      else
        "Hello again! Thank you for calling Dial-a-Haiku."
      end
    },
    after: :gather_inspiration

  # The after_update callback in app/models/response.rb watches for a transcription and enqueues the job which calls
  # the `GenerateHaikuOperation` which will make the slow API call to generate a haiku. I do not like this fragile
  # coupling to a callback. Ideally it would use an explicit event, or at the very least an observer, but neither are
  # supported by the `twilio-rails` framework... yet.
  prompt :gather_inspiration,
    message: "I am listening to you. Please inspire me. Describe in a few words the topic of the haiku you would like to hear.",
    gather: {
      type: :speech,
      language: "en-US",
      enhanced: true,
      speech_model: "phone_call",
      # speech_timeout: "auto",
      speech_timeout: 3,
    },
    after: ->(response) {
      if response.transcription.present?
        {
          message: "Perfect. Give me a moment to write your haiku.",
          prompt: :thinking,
        }
      else
        {
          message: "I am sorry, I did not hear you say anything. If you speak I can hear you.",
          prompt: :gather_inspiration,
        }
      end
    }

  prompt :thinking,
    message: [
      macros.play_public_file("chimes_up.wav"),
      macros.play_public_file("chimes_down.wav"),
    ],
    after: ->(response) {
      if macros.last_responses_all(response, prompt: :thinking, count: 3)
        :processing_error
      elsif macros.last_completed_haiku(response).blank?
        :thinking
      else
        :read_haiku
      end
    }

  prompt :read_haiku,
    message: ->(response) {
      [
        macros.last_completed_haiku(response),
        macros.pause(2),
      ]
    },
    after: :prompt_again_or_goodbye

  prompt :prompt_again_or_goodbye,
    message: "Would you like to hear another haiku?",
    gather: {
      type: :speech,
      language: "en-US",
      enhanced: true,
      speech_model: "numbers_and_commands",
      speech_timeout: "auto",
    },
    after: ->(response) {
      if response.answer_yes?
        {
          message: "Wonderful!",
          prompt: :gather_inspiration,
        }
      else
        {
          message: "Alright. You can call back anytime. I hope you enjoyed your haiku today. Goodbye.",
          hangup: true,
        }
      end
    }

  prompt :processing_error,
    message: "I am sorry, but I am having trouble processing your request. Please call again soon.",
    after: {
      hangup: true,
    }

end
