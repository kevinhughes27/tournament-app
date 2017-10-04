var browserstack = require('browserstack-local');

exports.config = {
  user: 'kevinhughes6',
  key: 'Ve3RnQbrSByPDz7UatGZ',

  specs: [
    './tests/spec.js'
  ],

  mochaOpts: {
    timeout: 20000
  },

  capabilities: [
    {
      'project': 'ut-player-app',
      'browserstack.local': true,
      'browserName': 'Chrome'
    },
    // {
    //   'project': 'ut-player-app',
    //   'browserstack.local': true,
    //   'browserName': 'Firefox'
    // },
    // {
    //   'project': 'ut-player-app',
    //   'browserstack.local': true,
    //   'browserName': 'Safari'
    // },
    // {
    //   'project': 'ut-player-app',
    //   'browserstack.local': true,
    //   'browserName': 'Edge'
    // },
    //
    // Gets stuck at Pin code. the pin is never checked with the server so the issue is client side.
    // Probably the onComplete of react-pin-input not firing
    // {
    //   'project': 'ut-player-app',
    //   'browserstack.local': true,
    //   'browserName': 'IE',
    //   'browser_version' : '11.0'
    // }
    {
      'project': 'ut-player-app',
      'browserstack.local': true,
      'realMobile': true,
      'device': 'Nexus 5'
    }
  ],

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