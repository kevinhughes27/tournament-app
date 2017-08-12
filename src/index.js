import React from 'react';
import ReactDom from 'react-dom';

import { createStore, applyMiddleware, combineReducers } from 'redux';
import { Provider } from 'react-redux';
import thunk from 'redux-thunk';

import createHistory from 'history/createBrowserHistory';
import { Route } from 'react-router';

import {
  ConnectedRouter,
  routerReducer,
  routerMiddleware
} from 'react-router-redux';

import App from './components/App';
import { loadApp } from './actions/load';
import reducers from './reducers';

import ScheduleList from './components/ScheduleList';
import Map from './components/Map';
import Submit from './components/Submit';

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
  applyMiddleware(thunk, middleware)
);

store.dispatch(loadApp());

injectTapEventPlugin();

ReactDom.render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <App>
        <Route exact path="/" component={ScheduleList} />
        <Route path="/map" component={Map} />
        <Route path="/submit" component={Submit} />
      </App>
    </ConnectedRouter>
  </Provider>,
  document.getElementById('root')
);

registerServiceWorker();
