FactoryBot.define do
  factory :response do
    phone_call

    prompt_handle { "gather_inspiration" }

    trait :transcribed do
      transcription { "spicy pickles" }
      transcribed { true }
    end
  end
end
