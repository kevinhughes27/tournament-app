const proxy = require('http-proxy-middleware');
const Bundler = require('parcel-bundler')
const express = require('express')

const app = express();

const handle = 'no-borders';
const domain = 'lvh.me';
const port = 3000;
const target = `${handle}.${domain}:${port}`

const httpOptions = {target: `http://${target}`, changeOrigin: true};
const wsOptions = {target: `ws://${target}`, changeOrigin: true, ws: true};

app.use(
  proxy('/graphql', httpOptions),
  proxy('/user_token', httpOptions),
  proxy('/subscriptions', wsOptions),
);

const bundler = new Bundler('src/index.html', {
  outDir: './build'
});

app.use(bundler.middleware());

app.listen(Number(process.env.PORT || 4000));
