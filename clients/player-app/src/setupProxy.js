const proxy = require('http-proxy-middleware');

const options = { target: 'http://no-borders.lvh.me:3000', changeOrigin: true };

module.exports = function(app) {
  app.use(proxy('/graphql', options));
};
