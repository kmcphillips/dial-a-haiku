# frozen_string_literal: true
Twilio::Rails.setup do |config|
  # These are the Twilio account credentials used to access the Twilio API. These should likely be configured in the
  # encrypted Rails credentials or loaded from an ENV variable.
  config.account_sid = ENV["TWILIO_RAILS_ACCOUNT_SID"]
  config.auth_token = ENV["TWILIO_RAILS_AUTH_TOKEN"]

  # This is the phone number that will be used to send SMS messages or start Phone Calls. It must be first configured
  # and purchased in the Twilio dashboard, then entered here. The format must be "+15556667777". In most applications it
  # is probably the only number, but in more complex applications it is the "main" or default number. It is used when
  # the phone number is not specified and the number otherwise cannot be intelligently guessed or inferred. This number
  # should likely be configured in the encrypted Rails credentials or loaded from an ENV variable.
  config.default_outgoing_phone_number = ENV["TWILIO_RAILS_NUMBER"]

  # All the following configuration options are optional and have reasonable defaults. Though if no phone trees or SMS
  # responders are registered then the app will not be able to do much.

  # Registry objects used to store and lookup phone trees and SMS responders. They must be registered here at setup time
  # in order for the application to be able to use them. They can either be defined as strings that will be
  # constantized, or as a block that will be evaluated after initialization. It is recommended to use the included
  # generators to create new phone trees and SMS responders, which will add the lines here to register them.
  #
  # See the README documentation for more information on how to define and register phone trees and SMS responders.
  config.phone_trees.register { HaikuTree }
  config.sms_responders.register { HaikuResponder }

  # This is the host that will be used to generate URLs that the Twilio API will use to make requests to the
  # application. It defaults to what is defined in Rails `default_url_options` but can be overridden here. The format
  # must be a protocol and domain, without the trailing slash, and no path.
  config.host = ENV["TWILIO_RAILS_HOST"]

  # The logger used by the framework. Defaults to `Rails.logger`. It cannot be `nil`, so to disable framework
  # logging explicitly set it to `Logger.new(nil)`.
  # config.logger = Rails.logger

  # The HTTP methods that Twilio will use to call into the app. Defaults to `[:get, :post]` but can be restricted
  # to just `[:get]` or `[:post]`. This must match the configuration in the Twilio dashboard.
  config.controller_http_methods = [:post]

  # Allows SMS messages to be filtered at source if they appear to be spam. This is an optional callable that is run
  # with raw params from Twilio on each request. If the callable returns `true` it will prevent the message from being
  # processed. This is useful for filtering out messages that are obviously spam. Setting this to `nil` will disable
  # the filter and is the default.
  # config.spam_filter = ->(params) {
  #   [ "Bad text" ].any? { |regex| regex.match?(params["Body"]) }
  # }

  # A proc that will be called when an exception is raised in certain key points in the framework. This will never
  # capture the exception, it will raise regardless, but it is a good spot to send an email or notify in chat
  # if desired. The proc needs to accept `(exception, message, context, exception_binding)` as arguments. The
  # default is `nil`, which means no action will be taken.
  # config.exception_notifier = ->(exception, message, context, exception_binding) {
  #   MyChatClient.send_message("Error: #{ message } #{ exception.message } #{ context }")
  # }

  # A list of strings to be interpreted as yes or acceptance to a question, when the response is transcribed. Used in
  # the phone macros. Defaults to a list of common responses.
  # config.yes_responses = ["yes"]

  # A list of strings to be interpreted as no or rejection to a question, when the response is transcribed. Used in
  # the phone macros. Defaults to a list of common responses.
  # config.no_responses = ["no"]

  # The name of the model classes, as strings, that this application uses to represent the concepts stored in the DB.
  # The generators will generate the models with the default names below, but they can be changed as the application
  # may need.
  # config.phone_caller_class_name = "PhoneCaller"
  # config.phone_call_class_name = "PhoneCall"
  # config.response_class_name = "Response"
  # config.sms_conversation_class_name = "SMSConversation"
  # config.message_class_name = "Message"
  # config.recording_class_name = "Recording"

  # Allows adding a module to be included into the `macros` in the phone tree DSL. This is useful for
  # adding convenience methods specific to the application. It can be called multiple times to add multiple modules.
  # Built in macros are defined in `Twilio::Rails::Phone::TreeMacros`.
  # config.include_phone_macros MyMacrosModule
  config.include_phone_macros PhoneMacros
end
