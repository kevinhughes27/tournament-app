# Be sure to restart your server when you modify this file.
domain = Rails.env.production? ? 'ultimate-tournament.io' : 'lvh.me'

Rails.application.config.session_store :cookie_store,
  key: '_ultimate-tournamet_session',
  domain: domain
