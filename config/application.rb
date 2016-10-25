require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

require_relative '../lib/subdomain'
require_relative '../lib/bracket_db/lib/bracket_db'

module UltimateTournament
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/lib/validators"]

    config.active_record.default_timezone = :local

    config.generators do |generate|
      generate.helper false
      generate.assets false
    end
  end
end
