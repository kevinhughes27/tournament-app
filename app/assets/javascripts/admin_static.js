
// This file is used in production to server generated JS assets. In development mode, we use the Webpack Dev Server
// to provide assets. This allows for hot reloading of the JS and CSS.
// See app/helpers/application_helper.rb for how the correct assets file is picked based on the Rails environment.
// Those helpers are used here: app/views/layouts/application.html.erb

// These assets are located in app/assets/webpack directory
// CRITICAL that webpack/vendor-bundle must be BEFORE turbolinks
// since it is exposing jQuery and jQuery-ujs

//= require bracket_db

//= require admin/admin
//= require_tree ./admin/lib
//= require_tree ./shared
//= require_tree ./admin/initializers
//= require_tree ./admin/modules

//= require vendor-bundle
//= require admin-bundle

// Non-webpack assets incl turbolinks
//= require admin_non_webpack
