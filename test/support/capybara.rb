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
