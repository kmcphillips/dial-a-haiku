# frozen_string_literal: true
class HaikuTree < Twilio::Rails::Phone::BaseTree
  voice "Polly.Joanna-Neural"

  final_timeout_message("You seem to be gone. I'm sorry to have lost you. Please call again soon.")
  invalid_phone_number("I'm sorry, but you must phone from a valid north american phone number. Goodbye.")

  greeting message: macros.play_public_file("chimes.wav"),
    prompt: :hello

  prompt :hello,
    message: ->(response) {
      "Hello."
    },
    after: {
      message: "Goodbye.",
      hangup: true
    }
end
