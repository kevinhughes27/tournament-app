const proxy = require('http-proxy-middleware');

const handle = 'no-borders';
const domain = 'lvh.me';
const port = 3000;
const target = `${handle}.${domain}:${port}`

const httpOptions = {target: `http://${target}`, changeOrigin: true};
const wsOptions = {target: `ws://${target}`, changeOrigin: true, ws: true}

module.exports = function(app) {
  app.use(
    proxy('/graphql', httpOptions),
    proxy('/user_token', httpOptions),
    proxy('/subscriptions', wsOptions),
  );
};
