exports.config = {
  framework: 'mocha',
  seleniumAddress: 'http://localhost:4444/wd/hub',
  baseUrl: 'http://localhost:5000',
  specs: ['spec/*.js'],
  onPrepare: () => {
    browser.ignoreSynchronization = true
    var width = 375
    var height = 667
    browser.driver.manage().window().setSize(width, height)

    require('babel-core/register')({presets: ['es2015']})
    require('./setup')
  },
  capabilities: {
    'browserName': 'firefox'
  },
  mochaOpts: {
    enableTimeouts: false,
  },
  allScriptsTimeout: 15000,
}