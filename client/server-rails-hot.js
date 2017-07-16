/* eslint no-var: 0, no-console: 0, import/no-extraneous-dependencies: 0 */

const webpack = require('webpack')
const WebpackDevServer = require('webpack-dev-server')
const webpackConfig = require('./webpack.client.rails.hot.config')
const webpackConfigLoader = require('react-on-rails/webpackConfigLoader')

const { resolve } = require('path')
const configPath = resolve('..', 'config')
const { hotReloadingUrl, hotReloadingPort, hotReloadingHostname } = webpackConfigLoader(configPath)

const compiler = webpack(webpackConfig)

const devServer = new WebpackDevServer(compiler, {
  proxy: {
    '*': `http://lvh.me:${hotReloadingPort}`
  },
  headers: {
    'Access-Control-Allow-Origin': '*'
  },
  disableHostCheck: true,
  contentBase: hotReloadingUrl,
  hot: true,
  inline: true,
  historyApiFallback: true,
  quiet: false,
  noInfo: false,
  lazy: false,
  stats: {
    colors: true,
    hash: false,
    version: false,
    chunks: false,
    children: false
  }
})

devServer.listen(hotReloadingPort, hotReloadingHostname, (err) => {
  if (err) console.error(err)
  console.log(
    `=> 🔥  Webpack development server is running on ${hotReloadingUrl}`
  )
})
