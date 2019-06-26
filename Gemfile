source 'https://rubygems.org'
ruby '2.6.3'

# server
gem 'rails', '5.2.2.1'
gem 'bootsnap'
gem 'puma'
gem 'config'
gem 'tzinfo-data'
gem 'active_operation'

# api
gem 'graphql', '~> 1.9'
gem 'graphql-batch'
gem 'graphiql-rails'

# websockets
gem 'actioncable'

# datastores
gem 'pg', '~> 1.1.4'
gem 'redis', '~> 3.0'

# auth
gem 'devise'
gem 'knock', git: 'https://github.com/kevinhughes27/knock.git', ref: '110bf5556ff2d5a6371356e2d6f546c728722057'
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

# assets
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'materialize-sass'
gem 'font-awesome-rails'
gem 'uglifier'

# javascript
gem 'jquery-rails'
gem 'js_cookie_rails'
gem 'jstz-rails3-plus'

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
  gem 'listen'
  gem 'wkhtmltopdf-binary-edge', '~> 0.12.3.0'
end

group :development do
  gem 'dotenv-rails'
  gem 'letter_opener'
  gem 'web-console'
end

group :test do
  gem 'mocha', :require => false
  gem 'simplecov', :require => false
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'hashdiff'
  gem 'deepsort'
  gem 'json-schema', '~> 2.6.0'
end

group :ci do
  gem 'minitest-retry'
  gem 'minitest-ci'
  gem 'bundler-audit', require: false
end
