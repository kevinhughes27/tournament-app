require 'simplecov'

if ENV['CI'] || ENV['COVERAGE']
  dir = File.join(Rails.root, 'tmp', 'coverage')
  SimpleCov.coverage_dir(dir)
  SimpleCov.start 'rails'
end
