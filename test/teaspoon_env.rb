Teaspoon.configure do |config|
  config.mount_at = "/teaspoon"
  config.root = nil
  config.asset_paths = ["test/javascripts"]
  config.fixture_paths = ["test/javascripts/fixtures"]

  config.suite do |suite|
    suite.use_framework :jasmine, "2.3.4"
    suite.matcher = "{test/javascripts, app/assets}/**/*spec.{js,coffee}"
    suite.helper = "spec_helper"
    suite.boot_partial = "bundle_boot"
    suite.body_partial = "body"
  end

  # config.use_coverage = :default
  # config.coverage do |coverage|
  #   coverage.reports = ["text-summary", "html"]
  #
  #   if ENV['CIRCLE_ARTIFACTS']
  #     coverage.output_path = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  #   else
  #     coverage.output_path = 'test/javascripts/coverage'
  #   end
  #
  #   coverage.ignore = [
  #     %r{/gems/},
  #     %r{/app/assets/javascripts/vendor/},
  #     %r{/support/},
  #     %r{/(.+)_helper.}
  #   ]
  # end
end
