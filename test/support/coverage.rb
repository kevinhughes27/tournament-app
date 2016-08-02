require 'simplecov'

# save to CircleCI's artifacts directory if we're on CircleCI
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
else
  dir = File.join(File.dirname(__FILE__), "coverage")
  SimpleCov.coverage_dir(dir)
end

if ENV['CIRCLE_ARTIFACTS'] || ENV['COVERAGE']
  SimpleCov.start 'rails'
end
