source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

gem "rails", "~> 7.0.1"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "jwt"
gem "sidekiq"
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "bootsnap", require: false
gem "rack-cors"

group :development, :test do
  gem "rubocop-rails"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "factory_bot_rails"
  gem 'faker'
  gem "database_cleaner-active_record"
end