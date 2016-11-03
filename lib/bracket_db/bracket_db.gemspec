require File.expand_path('../lib/bracket_db/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "bracket_db"
  spec.version       = BracketDb::VERSION
  spec.authors       = ["Kevin Hughes"]
  spec.email         = ["kevinhughes27@gmail.com"]
  spec.summary       = 'bracket_db for Ultimate Tournament'

  spec.files = Dir["lib/bracket_db.rb", "lib/bracket_db/*.rb", "db/data/*", "lib/assets/javascripts/*"]

  spec.add_runtime_dependency 'frozen_record', '~> 0.7.1'
  spec.add_runtime_dependency 'tilt'
  spec.add_runtime_dependency 'activesupport'
  spec.add_development_dependency 'json-schema', '~> 2.6.0'
end
