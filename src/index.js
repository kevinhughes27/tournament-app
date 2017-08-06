import React from 'react';
import { render } from 'react-dom';
import { createStore, applyMiddleware } from 'redux';
import { Provider } from 'react-redux';
import thunk from 'redux-thunk';

import App from './components/App';
import { loadApp } from './actions/load';
import playerApp from './reducers';

import './index.css';
import registerServiceWorker from './registerServiceWorker';

let store = createStore(playerApp, applyMiddleware(thunk));

store.dispatch(loadApp());

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
);

registerServiceWorker();
