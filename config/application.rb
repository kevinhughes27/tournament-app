require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

require_relative '../lib/subdomain'

module UltimateTournament
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.active_record.default_timezone = :local

    config.generators do |generate|
      generate.helper false
      generate.assets false
    end

    config.middleware.use Rack::Deflater
  end
end
