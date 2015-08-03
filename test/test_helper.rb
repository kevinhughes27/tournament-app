ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'

# circle ci uses older webkit and it doesn't work
if ENV['CIRCLECI']
  Capybara.current_driver = :selenium
else
  Capybara.current_driver = :webkit
end

Capybara.ignore_hidden_elements = false

Capybara::Webkit.configure do |config|
  config.allow_unknown_urls
end

class ActiveSupport::TestCase
  fixtures :all

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
end
