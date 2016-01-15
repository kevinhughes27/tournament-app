Teaspoon.configure do |config|
  config.mount_at = "/teaspoon"
  config.root = nil
  config.asset_paths = ["test/javascripts"]
  config.fixture_paths = ["test/javascripts/fixtures"]

  config.suite do |suite|
    suite.use_framework :jasmine, "2.3.4"
    suite.matcher = "{test/javascripts, app/assets}/**/*spec.{js,coffee}"
    suite.helper = 'test_helper'
    suite.boot_partial = "boot"
    suite.body_partial = "body"
  end

  # COVERAGE REPORTS / THRESHOLD ASSERTIONS
  #
  # Coverage reports requires Istanbul (https://github.com/gotwarlost/istanbul) to add instrumentation to your code and
  # display coverage statistics.
  #
  # Coverage configurations are similar to suites. You can define several, and use different ones under different
  # conditions.
  #
  # To run with a specific coverage configuration
  # - with the rake task: rake teaspoon USE_COVERAGE=[coverage_name]
  # - with the cli: teaspoon --coverage=[coverage_name]

  # Specify that you always want a coverage configuration to be used. Otherwise, specify that you want coverage
  # on the CLI.
  # Set this to "true" or the name of your coverage config.
  #config.use_coverage = nil

  # You can have multiple coverage configs by passing a name to config.coverage.
  # e.g. config.coverage :ci do |coverage|
  # The default coverage config name is :default.
  config.coverage do |coverage|
    # Which coverage reports Istanbul should generate. Correlates directly to what Istanbul supports.
    #
    # Available: text-summary, text, html, lcov, lcovonly, cobertura, teamcity
    #coverage.reports = ["text-summary", "html"]

    # The path that the coverage should be written to - when there's an artifact to write to disk.
    # Note: Relative to `config.root`.
    #coverage.output_path = "coverage"

    # Assets to be ignored when generating coverage reports. Accepts an array of filenames or regular expressions. The
    # default excludes assets from vendor, gems and support libraries.
    #coverage.ignore = [%r{/lib/ruby/gems/}, %r{/vendor/assets/}, %r{/support/}, %r{/(.+)_helper.}]

    # Various thresholds requirements can be defined, and those thresholds will be checked at the end of a run. If any
    # aren't met the run will fail with a message. Thresholds can be defined as a percentage (0-100), or nil.
    #coverage.statements = nil
    #coverage.functions = nil
    #coverage.branches = nil
    #coverage.lines = nil
  end
end
