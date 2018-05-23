require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

require_relative '../lib/subdomain'

module UltimateTournament
  class Application < Rails::Application
    config.active_record.default_timezone = :local

    config.autoload_paths << Rails.root.join('app/graphql/utils')

    config.generators do |generate|
      generate.helper false
      generate.assets false
    end

    config.middleware.use Rack::Deflater
  end
end
