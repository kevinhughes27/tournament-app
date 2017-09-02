import React from 'react';
import ReactDom from 'react-dom';

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
import { loadApp } from './actions/load';
import reducers from './reducers';

import './index.css';
import injectTapEventPlugin from 'react-tap-event-plugin';
import registerServiceWorker from './registerServiceWorker';

const history = createHistory();
const middleware = routerMiddleware(history);

const store = createStore(
  combineReducers({
    app: reducers,
    router: routerReducer
  }),
  applyMiddleware(thunk, logger, middleware)
);

window.tournament = {
  map: {
    lat: 45.2450109815466,
    long: -75.61416506767274,
    zoom: 16
  }
};

store.dispatch(loadApp());

injectTapEventPlugin();

ReactDom.render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <App />
    </ConnectedRouter>
  </Provider>,
  document.getElementById('root')
);

registerServiceWorker();
