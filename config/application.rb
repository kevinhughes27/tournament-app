require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module UltimateTournament
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |generate|
      generate.helper false
      generate.assets false
    end

    config.middleware.use Rack::Deflater
  end
end
