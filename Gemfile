# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

gem 'rails', '~> 7.0.2', '>= 7.0.2.3'

gem 'importmap-rails'
gem 'puma', '~> 5.0'
gem 'sprockets-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

gem 'aws-sdk-s3', require: false
gem 'bcrypt', '~> 3.1.7'
gem 'bugsnag', '~> 6.13', '>= 6.13.1'
gem 'device_detector'
gem 'dotenv-rails'
gem 'faraday'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'
gem 'jbuilder'
gem 'jwt'
gem 'pg', '~> 1.1'
gem 'redis', '~> 4.0'
gem 'sidekiq'
gem 'solana_rpc_ruby'
gem 'newrelic_rpm'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
gem 'sassc-rails'

gem 'bootstrap', '~> 5.1.3'

group :development, :test do
  gem 'byebug'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'annotate'
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
