# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'devise', '~> 4.7', '>= 4.7.2'
gem 'devise-jwt', '~> 0.8.0'
gem 'foreman'
gem 'geokit-rails'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rack-cors'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'

group :development, :test do
  gem 'amazing_print', '~> 1.2'
  gem 'factory_bot_rails', '~> 5.2'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  gem 'brakeman'
  gem 'listen', '~> 3.2'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails', '~> 4.0', '>= 4.0.1'
  gem 'shoulda-matchers', '~> 4.3'
  gem 'simplecov', '0.17.1'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
