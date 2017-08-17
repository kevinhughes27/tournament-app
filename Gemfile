source 'https://rubygems.org'
ruby '2.3.4'

# server
gem 'rails', '5.0.4'
gem 'actioncable'
gem 'puma'
gem 'config'
gem 'jbuilder'
gem 'composable_operations'

# api
gem 'graphql'
gem 'graphiql-rails'
gem 'rack-cors', require: 'rack/cors'

# controllers
gem 'browser-timezone-rails'
gem 'kaminari', git: 'https://github.com/amatsuda/kaminari'

# datastores
gem 'pg'
gem 'redis'
gem 'frozen_record'

# engines
gem 'devise', '~> 4.3.0'

# auth
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'

# model gems
gem 'activerecord-import'
gem 'paranoia', git: 'https://github.com/rubysherpas/paranoia', ref: '3c0d897a3e0eb49c7ff8ee7ad9ba221d41ff160a'
gem 'auto_strip_attributes'
gem 'date_validator'
gem 'phonelib'

# jobs
gem 'sidekiq'
gem 'sinatra', git: 'https://github.com/sinatra/sinatra', require: false # sidekiq web

# APIs
gem 'gibbon'

# exception tracking
gem 'rollbar'

# utils
gem 'wicked_pdf'

# asset gems
gem 'react_on_rails', '~> 8.0.3'
gem 'webpacker_lite', '2.0.4'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'uglifier', '>= 1.3.0'
gem 'sassc-rails'

# javascript gems
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'twine-rails'
gem 'turbolinks', '~> 5.0.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-leaflet', '~> 1.0.1'
  gem 'rails-assets-underscore', '~> 1.8.3'
  gem 'rails-assets-moment', '~> 2.10.6'
  gem 'rails-assets-fingerprintjs2' , '~> 0.7.4'
  gem 'rails-assets-jquery.scrollTo', '~> 2.1.2'
end

group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'wkhtmltopdf-heroku'
  gem 'rack-timeout'
end

group :development, :test do
  gem 'byebug', '~> 9.0.6'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'spring'
  gem 'bundler-audit', require: false
  gem 'rainbow'
  gem 'teaspoon'
  gem 'teaspoon-jasmine'
  gem 'teaspoon-bundle', '~> 0.1.6'
  gem 'wkhtmltopdf-binary-edge', '~> 0.12.3.0'
end

group :circleci do
  gem 'minitest-retry'
  gem 'minitest-ci', git: 'git@github.com:circleci/minitest-ci.git'
  gem 'json-schema', '~> 2.6.0'
end

group :development do
  gem 'dotenv-rails'
  gem 'bullet'
  gem 'letter_opener'
  gem 'web-console'
  gem 'rugged'
end

group :test do
  gem 'rails-controller-testing'
  gem 'mocha', :require => false
  gem 'timecop'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'nokogiri'
  gem 'launchy'
  gem 'simplecov', :require => false
end
