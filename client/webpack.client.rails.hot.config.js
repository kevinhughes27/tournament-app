// Run with Rails server like this:
// rails s
// cd client && babel-node server-rails-hot.js
// Note that Foreman (Procfile.dev) has also been configured to take care of this.

const webpack = require('webpack')
const merge = require('webpack-merge')
const { resolve } = require('path')
const config = require('./webpack.client.base.config')
const webpackConfigLoader = require('react-on-rails/webpackConfigLoader')

const configPath = resolve('..', 'config')
const { hotReloadingUrl, webpackOutputPath } = webpackConfigLoader(configPath)

module.exports = merge(config, {
  devtool: 'eval-source-map',

  entry: {
    'admin-bundle': [
      `webpack-dev-server/client?${hotReloadingUrl}`,
      'webpack/hot/only-dev-server'
    ]
  },

  output: {
    filename: '[name].js',
    path: webpackOutputPath,
    publicPath: `${hotReloadingUrl}/`
  },

  module: {
    rules: [
      {
        test: /\.jsx?$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
        query: {
          plugins: [
            [
              'react-transform',
              {
                superClasses: ['React.Component', 'BaseComponent', 'Component'],
                transforms: [
                  {
                    transform: 'react-transform-hmr',
                    imports: ['react'],
                    locals: ['module']
                  }
                ]
              }
            ]
          ]
        }
      }
    ]
  },

  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin()
  ]
})

console.log('Webpack HOT dev build for Rails') // eslint-disable-line no-console
