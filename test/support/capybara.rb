require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.configure do |config|
  config.current_driver = :poltergeist
  config.ignore_hidden_elements = false
  config.app_host = "http://lvh.me"
  config.always_include_port = true
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
