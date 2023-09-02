source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "puma", "~> 5.0"
gem "redis"
gem "sidekiq"
gem "bootsnap", require: false
gem "activerecord-session_store"
gem "active_operation"
gem "faraday"
gem "aws-sdk-s3"
gem "ruby-openai", ">= 3.3.0", require: "openai"

gem "twilio-rails", "~> 1.0.0"

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

group :production do
  gem "mysql2", "~> 0.5.5"
end

gem "dockerfile-rails", ">= 1.0", :group => :development
