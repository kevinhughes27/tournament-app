require 'capybara/rails'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

# circle ci uses older webkit and it doesn't work
if ENV['CIRCLECI']
  Capybara.current_driver = :selenium_chrome
else
  Capybara.current_driver = :webkit
end

Capybara.ignore_hidden_elements = false

Capybara::Webkit.configure do |config|
  config.allow_unknown_urls
  #config.debug = true
end

class ActiveSupport::TestCase
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
