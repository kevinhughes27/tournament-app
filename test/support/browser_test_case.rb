require 'capybara/rails'
require 'selenium-webdriver'

DEFAULT_CHROME_OPTIONS = [
  'disable-gpu'
].freeze

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: DEFAULT_CHROME_OPTIONS }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: DEFAULT_CHROME_OPTIONS + ['headless'] }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.default_driver = Capybara.javascript_driver = :chrome
Capybara.current_driver = ENV['CI'] ? :headless_chrome : :chrome

Capybara.configure do |config|
  config.ignore_hidden_elements = false
  config.app_host = "http://#{Settings.domain}"
  config.server_port = 3000
  config.always_include_port = true
end

class BrowserTestCase < ActiveSupport::TestCase
  include Capybara::DSL
  self.use_transactional_tests = false

  setup do
    ReactOnRails::TestHelper.ensure_assets_compiled
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean

    path = screenshot_path(method_name)
    page.save_screenshot(path) unless passed?

    Capybara.reset_sessions!
  end

  def screenshot_path(name)
    screenshot_file = "#{name}.png"
    File.join(Rails.root, 'tmp', 'capybara', screenshot_file)
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
