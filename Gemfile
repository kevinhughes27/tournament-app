source 'https://rubygems.org'
ruby '2.2.3'

# rails gems
gem 'rails', '5.0.0.beta4'
gem 'puma'
gem 'wicked'
gem 'responders'
gem 'render_anywhere', require: false
gem 'json-schema', '~> 2.6.0'
gem 'jbuilder'
gem 'wicked_pdf'
gem 'browser-timezone-rails'

# model gems
gem 'friendly_id'
gem 'frozen_record', git: 'https://github.com/kevinhughes27/frozen_record', ref: '48f569c2ca3e60fa76b8b99bdf7d33c91bcdc1ee'
gem 'paranoia', git: 'https://github.com/rubysherpas/paranoia', ref: '3c0d897a3e0eb49c7ff8ee7ad9ba221d41ff160a'
gem 'auto_strip_attributes'
gem 'date_validator'
gem 'phonelib'

# exception tracking
gem 'rollbar'

# engines
gem 'devise', '~> 4.0.1'

# auth
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'

# asset gems
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 5.0'

# javascript gems
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks', git: 'https://github.com/turbolinks/turbolinks-classic', ref: '37a7c296232d20a61bd1946f600da7f2009189db'
gem 'twine-rails'
gem 'react-rails', '~> 1.7.0'
gem 'browserify-rails', '~> 3.0.1'

source 'https://rails-assets.org' do
  gem 'rails-assets-leaflet', '~> 1.0.0.beta.2'
  gem 'rails-assets-underscore', '~> 1.8.3'
  gem 'rails-assets-moment', '~> 2.10.6'
  gem 'rails-assets-fingerprintjs2' , '~> 0.7.4'
  gem 'rails-assets-jquery.scrollTo', '~> 2.1.2'
  gem 'rails-assets-tether', '~> 1.3.1'
  gem 'rails-assets-tether-drop', '~> 1.4.2'
  gem 'rails-assets-vis', '~> 4.15'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'wkhtmltopdf-heroku'
  gem 'rack-timeout'
end

group :development, :test do
  gem 'sqlite3'
  gem 'wkhtmltopdf-binary-edge', '~> 0.12.3.0'
  gem 'byebug'
  gem 'faker'
  gem 'spring'
  gem 'bundler-audit', require: false
  gem 'teaspoon-jasmine', '~> 2.3.4'
end

group :development do
  gem 'dotenv-rails'
  gem 'bullet'
  gem 'letter_opener'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'mocha', :require => false
  gem 'minitest-rg'
  gem 'timecop'
  gem 'capybara'
  gem 'poltergeist'
  gem 'chunky_png'
  gem 'launchy'
  gem 'simplecov', :require => false
  gem 'minitest-ci', :git => 'git@github.com:circleci/minitest-ci.git'
end
