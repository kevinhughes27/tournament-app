import { createStore, applyMiddleware, combineReducers } from 'redux';
import { connectRouter, routerMiddleware } from 'connected-react-router';
import thunk from 'redux-thunk';
import logger from 'redux-logger';
import history from './history';
import reducers from '../reducers';

const rootReducer = (history) => combineReducers({
  ...reducers,
  router: connectRouter(history)
});

const middleware = routerMiddleware(history);

const store = createStore(
  rootReducer(history),
  applyMiddleware(thunk, logger, middleware)
);

export default store;
