ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

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
