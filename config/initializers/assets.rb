# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

Rails.application.config.browserify_rails.commandline_options =
  "-t browserify-shim -t reactify --extension=\".js.jsx\""

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += [
  'landing.css', 'landing.js', 'admin.css', 'admin.js', 'app.css', 'app.js', 'fingerblast.js'
]
