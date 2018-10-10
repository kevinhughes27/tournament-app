ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

if ENV['CI']
  require 'minitest/ci'
  Minitest::Ci.new.start

  require 'minitest/retry'
  Minitest::Retry.use!(retry_count: 2, verbose: false)
end

ActiveRecord::Migration.maintain_test_schema!

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
