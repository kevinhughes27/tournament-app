# Be sure to restart your server when you modify this file.
Rails.application.config.session_store :cookie_store,
  key: '_ultimate-tournament_session',
  domain: Settings.host.gsub(':3000', '')
