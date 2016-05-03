require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module UltimateTournament
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/lib/**/"].reject{|d| d['tasks']}
    config.active_record.default_timezone = :local
  end
end
