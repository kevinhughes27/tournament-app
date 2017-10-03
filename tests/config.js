var browserstack = require('browserstack-local');

exports.config = {
  user: 'kevinhughes6',
  key: 'Ve3RnQbrSByPDz7UatGZ',

  specs: [
    './tests/specs/*.js'
  ],

  capabilities: [{
    browser: 'chrome',
    'browserstack.local': true
  }],

  // Code to start browserstack local before start of test
  onPrepare: function (config, capabilities) {
    console.log("Connecting local");
    return new Promise(function(resolve, reject){
      exports.bs_local = new browserstack.Local();
      exports.bs_local.start({'key': exports.config.key }, function(error) {
        if (error) return reject(error);
        console.log('Connected. Now testing...');

        resolve();
      });
    });
  },

  // Code to stop browserstack local after end of test
  onComplete: function (capabilties, specs) {
    exports.bs_local.stop(function() {});
  }
}