ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'capybara/rails'
Capybara.current_driver = :webkit
#Capybara.current_driver = :selenium
Capybara.ignore_hidden_elements = false

Capybara::Webkit.configure do |config|
  config.allow_unknown_urls
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

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end
