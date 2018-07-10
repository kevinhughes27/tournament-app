// Run like this:
// cd client && npm run build:client
// Note that Foreman (Procfile.dev) has also been configured to take care of this.

const merge = require('webpack-merge')
const config = require('./webpack.client.base.config')
const { resolve } = require('path')
const webpackConfigLoader = require('react-on-rails/webpackConfigLoader')

const configPath = resolve('..', 'config')
const { output, settings } = webpackConfigLoader(configPath)

const devBuild = process.env.NODE_ENV !== 'production'

if (devBuild) {
  console.log('Webpack dev build for Rails') // eslint-disable-line no-console
  config.devtool = 'eval-source-map'
} else {
  console.log('Webpack production build for Rails') // eslint-disable-line no-console
}

module.exports = merge(config, {
  output: {
    filename: '[name]-[hash].js',

    // Leading and trailing slashes ARE necessary.
    publicPath: `/${output.publicPath}/`,
    path: output.path
  },

  // See webpack.client.base.config for adding modules common to both webpack dev server and rails

  module: {
    rules: [
      {
        test: /\.jsx?$/,
        use: 'babel-loader',
        exclude: /node_modules/
      },
      {
        test: require.resolve('react'),
        use: {
          loader: 'imports-loader',
          options: {
            shim: 'es5-shim/es5-shim',
            sham: 'es5-shim/es5-sham'
          }
        }
      }
    ]
  }
})
