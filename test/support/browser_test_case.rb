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
  config.app_host = "http://#{Settings.host}"
  config.server_port = 3000
  config.always_include_port = true
end

class BrowserTestCase < ActiveSupport::TestCase
  include Capybara::DSL

  setup do
    ReactOnRails::TestHelper.ensure_assets_compiled
  end

  teardown do
    save_artifacts(method_name) unless passed?
    clear_application_storage
  end

  def assert_text(*args)
    begin
      super
    rescue Capybara::ExpectationNotMet => e
      text = args[0]
      message = "Unable to find text \"#{text}\" check the saved screenshot/html to see what went wrong"
      raise message
    end
  end

  private

  def save_artifacts(name)
    page.save_page html_path(name)
    page.save_screenshot screenshot_path(name)
  end

  def html_path(name)
    html_file = "#{name}.html"
    File.join(Rails.root, 'tmp', 'capybara', html_file)
  end

  def screenshot_path(name)
    screenshot_file = "#{name}.png"
    File.join(Rails.root, 'tmp', 'capybara', screenshot_file)
  end

  def clear_application_storage
    page.driver.browser.manage.delete_all_cookies
    page.execute_script('window.localStorage.clear();')
  end
end
