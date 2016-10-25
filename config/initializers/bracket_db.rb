# bracket_db should be a standalone gem but heroku caches locally pathed gems
# and I cant figure out a good way to break it.
require_relative '../../lib/bracket_db/lib/bracket_db'
Rails.application.config.assets.paths << Rails.root.join("lib", "bracket_db", "lib", "assets", "javascripts")
