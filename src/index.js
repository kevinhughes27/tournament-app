import React from 'react';
import ReactDom from 'react-dom';
import ReactGA from 'react-ga';

import { Provider } from 'react-redux';
import { ConnectedRouter } from 'react-router-redux';

import App from './components/App';
import { store, history } from './store';

import './index.css';
import injectTapEventPlugin from 'react-tap-event-plugin';

ReactGA.initialize('UA-76316112-3');
injectTapEventPlugin();

function logPageView() {
  if (window.location.hostname !== 'localhost') {
    ReactGA.set({ page: window.location.pathname });
    ReactGA.pageview(window.location.pathname);
  }
}

ReactDom.render(
  <Provider store={store}>
    <ConnectedRouter history={history} onUpdate={logPageView}>
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
