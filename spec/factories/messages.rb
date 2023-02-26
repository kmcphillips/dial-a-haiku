FactoryBot.define do
  factory :message do
    sid { "SM5073183d7484999999999999747bf790" }
    body { "Oh, hello."}
    status { "delivered" }
    direction { "outbound" }

    sms_conversation

    trait :inbound do
      direction { "inbound" }
      status { nil }
      sid { nil }
    end
  end
end
