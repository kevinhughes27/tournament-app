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

    if (process.env.CI) {
      const threadLoader = config.module.rules[3].oneOf[1].use[0];
      config.module.rules[3].oneOf[1].use[0] = {
        loader: threadLoader,
        options: {
          workers: process.env.CIRCLE_NODE_TOTAL
        }
      }
    }

    return config;
  },
  jest: function(config) {
    return rewireTypescriptJest(config);
  }
};
