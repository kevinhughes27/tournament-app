ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'capybara/rails'
Capybara.javascript_driver = :webkit
Capybara.current_driver = :webkit

Capybara::Webkit.configure do |config|
  config.allow_url("maps.googleapis.com")
  config.allow_url("maps.gstatic.com")
  config.allow_url("maxcdn.bootstrapcdn.com")
  config.allow_url("www.google-analytics.com")
end

require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

def http_login(username, password)
  creds = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  request.env['HTTP_AUTHORIZATION'] = creds
end
