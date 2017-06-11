# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += [
  'brochure.css',
  'brochure.js',
  'brochure/vendor.js',
  'admin.css',
  'admin.js',
  'admin/vendor.js',
  'schedule_pdf.css',
  'app.css',
  'app.js',
  'app/vendor.js',
  'internal.js',
]
