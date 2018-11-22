const proxy = require('http-proxy-middleware');

const handle = 'no-borders';
const domain = 'lvh.me';
const port = 3000;

const httpOptions = {target: `http://${handle}.${domain}:${port}`, changeOrigin: true};
const wsOptions = {target: `ws://${handle}.${domain}:${port}`, changeOrigin: true, ws: true}

module.exports = function(app) {
  app.use(
    proxy('/graphql', httpOptions),
    proxy('/user_token', httpOptions),
    proxy('/subscriptions', wsOptions),
  );
};
