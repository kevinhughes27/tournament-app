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
Capybara.always_include_port = true

Capybara::Webkit.configure do |config|
  config.allow_unknown_urls
  #config.debug = true
end

class BrowserTest < ActiveSupport::TestCase
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup do
    @user = users(:kevin)
    @tournament = tournaments(:noborders)
    @domain = "lvh.me"
  end

  teardown do
    path = screenshot_path(method_name)
    page.save_screenshot(path) unless passed?
    Capybara.reset_sessions!
  end

  def screenshot_path(name)
    if ENV['CIRCLECI']
      File.join(ENV['CIRCLE_ARTIFACTS'], "#{name}.png")
    else
      "tmp/#{name}.png"
    end
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
