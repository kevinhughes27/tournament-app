// Common client-side webpack configuration used by webpack.hot.config and webpack.rails.config.

const webpack = require('webpack')
const ManifestPlugin = require('webpack-manifest-plugin')
const { resolve } = require('path')
const webpackConfigLoader = require('react-on-rails/webpackConfigLoader')

const configPath = resolve('..', 'config')
const { manifest } = webpackConfigLoader(configPath)

const devBuild = process.env.NODE_ENV !== 'production'

module.exports = {

  // the project dir
  context: __dirname,
  entry: {
    // This will contain the app entry points defined by
    // webpack.client.rails.hot.config and webpack.client.rails.build.config

    // See use of 'vendor-bundle' in the CommonsChunkPlugin inclusion below.
    'vendor-bundle': [
      'babel-polyfill',
      'es5-shim/es5-shim',
      'es5-shim/es5-sham'
    ],

    // This will contain the app entry points defined by webpack.hot.config and webpack.rails.config
    'admin-bundle': [
      './admin/clientRegistration'
    ]
  },

  resolve: {
    extensions: ['.js', '.jsx'],
    modules: [
      'client/admin',
      'client/node_modules'
    ]
  },

  plugins: [
    new webpack.EnvironmentPlugin({
      NODE_ENV: 'development', // use 'development' unless process.env.NODE_ENV is defined
      DEBUG: false,
      TRACE_TURBOLINKS: devBuild
    }),

    // https://webpack.github.io/docs/list-of-plugins.html#2-explicit-vendor-chunk
    new webpack.optimize.CommonsChunkPlugin({

      // This name 'vendor-bundle' ties into the entry definition
      name: 'vendor-bundle',

      // Passing Infinity just creates the commons chunk, but moves no modules into it.
      // In other words, we only put what's in the vendor entry definition in vendor-bundle.js
      minChunks: Infinity
    }),
    new ManifestPlugin({
      fileName: manifest,
      writeToFileEmit: true
    })
  ],

  module: {
    loaders: []
  }
}
