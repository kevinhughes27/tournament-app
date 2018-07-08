# Shown below are the defaults for configuration
ReactOnRails.configure do |config|
  # Directory where your generated assets go
  config.generated_assets_dir = File.join(%w[public webpack], Rails.env)

  # Define the files for we need to check for webpack compilation when running tests
  config.webpack_generated_files = %w( admin-bundle.js vendor-bundle.js )

  config.node_modules_location = "client"

  # This is the file used for server rendering of React when using `(prerender: true)`
  # If you are never using server rendering, you may set this to "".
  # If you are using the same file for client and server rendering, having this set probably does
  # not affect performance.
  config.server_bundle_js_file = ""

  # If you are using the ReactOnRails::TestHelper.configure_rspec_to_compile_assets(config)
  # with rspec then this controls what npm command is run
  # to automatically refresh your webpack assets on every test run.
  config.build_test_command = "yarn run build"

  # This configures the script to run to build the production assets by webpack. Set this to nil
  # if you don't want react_on_rails building this file for you.
  config.build_production_command = ""

  ################################################################################
  # CLIENT RENDERING OPTIONS
  # Below options can be overriden by passing options to the react_on_rails
  # `render_component` view helper method.
  ################################################################################

  # Default is false. Can be overriden at the component level.
  # Set to false for debugging issues before turning on to true.
  config.prerender = false

  # default is true for development, off otherwise
  config.trace = Rails.env.development?

  ################################################################################
  # MISCELLANEOUS OPTIONS
  ################################################################################
  # This allows you to add additional values to the Rails Context. Implement one static method
  # called `custom_context(view_context)` and return a Hash.
  config.rendering_extension = nil

  # Client js uses assets not digested by rails.
  # For any asset matching this regex, non-digested symlink will be created
  # To disable symlinks set this parameter to nil.
  config.symlink_non_digested_assets_regex = nil
end
