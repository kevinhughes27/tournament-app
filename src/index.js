import React from 'react';
import ReactDom from 'react-dom';
import ReactGA from 'react-ga';

import { Provider } from 'react-redux';
import { ConnectedRouter } from 'react-router-redux';

import './index.css';
import injectTapEventPlugin from 'react-tap-event-plugin';

import App from './components/App';
import store from './store';
import history from './history';

ReactGA.initialize('UA-76316112-3');
injectTapEventPlugin();

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
