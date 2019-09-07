import React from 'react';
import ReactDom from 'react-dom';
import ReactGA from 'react-ga';

import { Provider } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';

import './index.css';

import App from './components/App';
import store from './store';
import history from './history';

ReactGA.initialize('UA-76316112-3');

ReactDom.render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <App />
    </ConnectedRouter>
  </Provider>,
  document.getElementById('root')
);

// unregister service worker
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.ready.then(registration => {
    registration.unregister();
  });
}
