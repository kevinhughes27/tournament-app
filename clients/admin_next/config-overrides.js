const {
  rewireWebpack: rewireTypescript,
  rewireJest: rewireTypescriptJest,
  rewireTSLint
} = require("react-app-rewire-typescript-babel-preset");
const { injectBabelPlugin } = require("react-app-rewired");

module.exports = {
  webpack: function(config, env) {
    config = rewireTypescript(config);
    config = rewireTSLint(config);
    config = injectBabelPlugin(["relay", { "artifactDirectory": "./src/generated" }], config);
    return config;
  },
  jest: function(config) {
    return rewireTypescriptJest(config);
  }
};
