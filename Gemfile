source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.4"

gem "rails", "~> 7.1.0"
gem "trilogy"
gem "mysql2", "~> 0.5.5"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "puma", "~> 5.0"
gem "redis"
gem "sidekiq"
gem "bootsnap", require: false
gem "activerecord-session_store"
gem "active_operation"
gem "faraday"
gem "aws-sdk-s3"
gem "ruby-openai"
gem "base64"
gem "bigdecimal"
gem "observer"
gem "ostruct"
gem "benchmark"
gem "irb"
gem "reline"
gem "fiddle"
gem "mutex_m" # Works around LoadError: cannot load such file -- mutex_m
gem "concurrent-ruby", "1.3.4" # Works around uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger

gem "twilio-rails", "~> 1.0.1"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
  gem "sqlite3", "~> 1.4"
  gem "dotenv-rails"
  gem "factory_bot_rails"
end

group :test do
  gem "webmock"
end

gem "dockerfile-rails", ">= 1.0", group: :development
