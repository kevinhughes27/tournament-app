source 'https://rubygems.org'
ruby '2.5.1'

# server
gem 'rails', '5.2.0'
gem 'bootsnap'
gem 'puma'
gem 'config'
gem 'jbuilder'
gem 'tzinfo-data'
gem 'active_operation'

# api
gem 'graphql'
gem 'graphiql-rails'

# websockets
gem 'actioncable'

# datastores
gem 'pg', '~> 0.21.0'
gem 'redis', '~> 3.0'

# auth
gem 'devise'
gem 'knock'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'

# model gems
gem 'activerecord-import'
gem 'paranoia', '~> 2.4.1'
gem 'auto_strip_attributes'
gem 'date_validator'
gem 'phonelib'

# internal area pagination
gem 'kaminari', git: 'https://github.com/amatsuda/kaminari'

# jobs
gem 'sidekiq'
gem 'sinatra', require: false # sidekiq web

# APIs
gem 'gibbon'

# exception tracking
gem 'rollbar'

# utils
gem 'wicked_pdf'

# asset gems
gem 'react_on_rails', '11.0.9'
gem 'webpacker'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'uglifier', '~> 3.2.0'
gem 'sassc-rails'

# javascript gems
gem 'coffee-rails'
gem 'jquery-rails'
gem 'js_cookie_rails'
gem 'jstz-rails3-plus'
gem 'twine-rails'
gem 'turbolinks', '~> 5.0.0'

group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'wkhtmltopdf-heroku'
  gem 'rack-timeout'
end

group :development, :test do
  gem 'byebug', '~> 9.0.6'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'spring'
  gem 'rainbow'
  gem 'listen'
  gem 'wkhtmltopdf-binary-edge', '~> 0.12.3.0'
end

group :development do
  gem 'dotenv-rails'
  gem 'bullet'
  gem 'letter_opener'
  gem 'web-console'
end

group :test do
  gem 'mocha', :require => false
  gem 'simplecov', :require => false
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'launchy'
  gem 'json-schema', '~> 2.6.0'
end

group :ci do
  gem 'minitest-retry'
  gem 'minitest-ci'
  gem 'bundler-audit', require: false
end
