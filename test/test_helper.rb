require 'simplecov'

# save to CircleCI's artifacts directory if we're on CircleCI
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
else
  dir = File.join(File.dirname(__FILE__), "coverage")
  SimpleCov.coverage_dir(dir)
end

SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
require 'minitest/rg'

OmniAuth.config.test_mode = true

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

class ActionController::TestCase
  include Devise::TestHelpers

  def set_tournament(tournament)
    subdomain = tournament.try(:handle) || tournament
    @request.host = "#{subdomain}.ultimate-tournament.io"
  end
end

class ActiveSupport::TestCase
  fixtures :all

  def stub_constant(mod, const, value)
    original = mod.const_get(const)

    begin
      mod.instance_eval { remove_const(const); const_set(const, value) }
      yield
    ensure
      mod.instance_eval { remove_const(const); const_set(const, original) }
    end
  end

  def response_json
    JSON.parse(@response.body)
  end
end
