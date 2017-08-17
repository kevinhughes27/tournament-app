require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

require_relative '../lib/subdomain'

module UltimateTournament
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    config.active_record.default_timezone = :local

    config.generators do |generate|
      generate.helper false
      generate.assets false
    end
  end
end
