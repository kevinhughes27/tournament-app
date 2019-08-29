const proxy = require('http-proxy-middleware');

const handle = 'no-borders';
const domain = 'lvh.me';
const port = 3000;
const target = `${handle}.${domain}:${port}`;

const httpOptions = { target: `http://${target}`, changeOrigin: true };
const wsOptions = { target: `ws://${target}`, changeOrigin: true, ws: true };

function proxyHttp(target) {
  return proxy(target, httpOptions)
};

function proxySocket(target) {
  return proxy(target, wsOptions)
};

module.exports = function(app) {
  app.use(
    proxyHttp('/user_token'),

    proxyHttp('/graphql'),
    proxySocket('/subscriptions'),

    proxyHttp('/fields.csv'),
    proxyHttp('/score_reports.csv'),
    proxyHttp('/schedule.pdf'),
  );
};
