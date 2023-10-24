source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"
gem "rails", :github => "rails/rails", :branch => "main"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "tailwindcss-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

gem "litestack", "~> 0.3.0"
gem "dockerfile-rails", ">= 1.5", :group => :development
gem "sentry-ruby", "~> 5.11"
gem "sentry-rails", "~> 5.11"
gem "devise", "~> 4.9"
gem "actionmailer", "~> 7.0"
gem "sqlite-ulid", "~> 0.2.1"
gem "rufus-scheduler", "~> 3.9"
gem "dotenv-rails", groups: [:development, :test]
gem "redcarpet", "~> 3.6"
gem "chartkick", "~> 5.0"
gem "importmap-rails", "~> 1.2"
gem "stimulus-rails"
