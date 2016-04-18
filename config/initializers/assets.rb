# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += [
  'brochure.css',
  'brochure.js',
  'brochure_vendor.js',
  'admin.css',
  'admin.js',
  'admin_vendor.js',
  'schedule_pdf.css',
  'app.css',
  'app.js',
  'app_vendor.js',
]

Rails.application.config.browserify_rails.commandline_options = [
  "-t browserify-shim",
  "-t babelify --extension='.jsx'",
]
