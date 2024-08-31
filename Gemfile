# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bootsnap', require: false
gem 'delayed_job_active_record', '~> 4.1'
gem 'devise', '~> 4.9'
gem 'faraday'
gem 'importmap-rails'
gem 'jbuilder'
gem 'omniauth', '~> 2.1'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-spotify', '~> 0.0.13'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.2.1'
gem 'redis', '>= 4.0.1'
gem 'sprockets-rails'
gem 'sqlite3', '>= 1.4'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-rails'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
