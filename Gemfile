source 'https://rubygems.org'
ruby "2.2.2"

# rails gems
gem 'rails', '4.2.1'
gem 'unicorn'
gem 'friendly_id'
gem 'responders'
gem 'json-schema'
gem 'jbuilder'

gem 'date_validator'
gem 'browser-timezone-rails'

# engines
gem 'devise'
gem 'devise_custom_authenticatable'

# frontend gems
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'

gem 'interact-rails'

# frontend frameworks
gem 'twine-rails'
gem 'turbolinks', github: 'rails/turbolinks', branch: 'master'
gem 'react-rails', github: 'reactjs/react-rails', branch: 'master'
gem 'browserify-rails'

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'sqlite3'
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :test do
  gem 'mocha', :require => false
  gem 'timecop'
  gem 'jasmine-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'capybara-webkit'
  gem 'launchy'
end
