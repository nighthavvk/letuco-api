# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1' # ruby '2.3.1'

gem 'pg'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.1'

gem 'devise'
gem 'devise_invitable'
gem 'devise_token_auth'
gem 'omniauth-facebook'

gem 'dotenv-rails', groups: %i[development test]

gem 'active_model_serializers'
gem 'bootsnap', require: false
gem 'rack-cors'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.0'
  gem 'faker'
  gem 'pry'
  gem 'rspec-rails', '~> 3.7'
end

group :development do
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'simplecov', require: false, group: :test
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
