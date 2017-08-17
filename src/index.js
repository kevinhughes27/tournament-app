import React from 'react';
import ReactDom from 'react-dom';

import { createStore, applyMiddleware, combineReducers } from 'redux';
import { Provider } from 'react-redux';

import createHistory from 'history/createBrowserHistory';
import { Route } from 'react-router';

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

import ScheduleList from './components/ScheduleList';
import MapView from './components/MapView';
import Submit from './components/Submit';
import ScoreForm from './components/ScoreForm';

import './index.css';
import injectTapEventPlugin from 'react-tap-event-plugin';
import registerServiceWorker from './registerServiceWorker';

const history = createHistory();

const middleware = routerMiddleware(history);

window.tournament = {
  map: {
    lat: 45.2450109815466,
    long: -75.61416506767274,
    zoom: 16
  }
};

const store = createStore(
  combineReducers({
    app: reducers,
    router: routerReducer
  }),
  applyMiddleware(thunk, logger, middleware)
);

store.dispatch(loadApp());

injectTapEventPlugin();

ReactDom.render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <App>
        <Route exact path="/" component={ScheduleList} />
        <Route path="/map" component={MapView} />
        <Route exact path="/submit" component={Submit} />
        <Route path="/submit/:gameId" component={ScoreForm} />
      </App>
    </ConnectedRouter>
  </Provider>,
  document.getElementById('root')
);

registerServiceWorker();
