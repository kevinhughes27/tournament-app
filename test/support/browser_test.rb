require 'capybara/rails'

Capybara::Webkit.configure do |config|
  config.allow_unknown_urls
end

Capybara.configure do |config|
  config.current_driver = :webkit
  config.ignore_hidden_elements = false
  config.app_host = "http://#{Settings.domain}"
  config.server_port = 3000
  config.always_include_port = true
end

class BrowserTest < ActiveSupport::TestCase
  include Capybara::DSL
  self.use_transactional_tests = false

  setup do
    @user = users(:kevin)
    @tournament = tournaments(:noborders)
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
