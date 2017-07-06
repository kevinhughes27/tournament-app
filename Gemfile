source 'https://rubygems.org'
ruby '2.3.1'

# rails gems
gem 'rails', '5.0.0.1'
gem 'pg'
gem 'puma'
gem 'actioncable'
gem 'sidekiq'
gem 'sinatra', git: 'https://github.com/sinatra/sinatra', require: false # sidekiq web
gem 'redis'
gem 'wicked'
gem 'kaminari', git: 'https://github.com/amatsuda/kaminari'
gem 'jbuilder'
gem 'wicked_pdf'
gem 'browser-timezone-rails'
gem 'config'
gem 'composable_operations'

# model gems
gem 'paranoia', git: 'https://github.com/rubysherpas/paranoia', ref: '3c0d897a3e0eb49c7ff8ee7ad9ba221d41ff160a'
gem 'auto_strip_attributes'
gem 'date_validator'
gem 'phonelib'

#gem 'bracket_db', '0.0.2', path: 'lib/bracket_db'
gem 'frozen_record'

# APIs
gem 'gibbon'

# exception tracking
gem 'rollbar'

# engines
gem 'devise', git: 'https://github.com/plataformatec/devise', ref: 'a20cca68733c422116dabb66f28fe769e0bf303b'

# auth
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'

# asset gems
gem 'react_on_rails', '~> 6.1.2'
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
  gem 'rails-assets-tether', '~> 1.3.1'
  gem 'rails-assets-tether-drop', '~> 1.4.2'
end

group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'wkhtmltopdf-heroku'
  gem 'rack-timeout'
end

group :development, :test do
  gem 'pry'
  gem 'pry-byebug', '1.3.3' #https://github.com/deivid-rodriguez/pry-byebug/issues/33
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'faker'
  gem 'spring'
  gem 'bundler-audit', require: false
  gem 'rainbow'
  gem 'teaspoon'
  gem 'teaspoon-jasmine'
  gem 'teaspoon-bundle', '~> 0.1.3'
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
  gem 'capybara-webkit'
  gem 'nokogiri'
  gem 'launchy'
  gem 'simplecov', :require => false
end
