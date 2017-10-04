import React from 'react';
import ReactDom from 'react-dom';
import ReactGA from 'react-ga';

import createHistory from 'history/createBrowserHistory';
import { createStore, applyMiddleware, combineReducers } from 'redux';
import { Provider } from 'react-redux';

import {
  ConnectedRouter,
  routerReducer,
  routerMiddleware
} from 'react-router-redux';

import thunk from 'redux-thunk';
import logger from 'redux-logger';

import App from './components/App';
import reducers from './reducers';

import './index.css';
import injectTapEventPlugin from 'react-tap-event-plugin';
import registerServiceWorker from './registerServiceWorker';

const history = createHistory();
const middleware = routerMiddleware(history);

const store = createStore(
  combineReducers({
    ...reducers,
    router: routerReducer
  }),
  applyMiddleware(thunk, logger, middleware)
);

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

registerServiceWorker();
