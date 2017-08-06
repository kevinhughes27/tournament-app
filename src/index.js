import React from 'react';
import { render } from 'react-dom';
import { createStore, applyMiddleware } from 'redux';
import { Provider } from 'react-redux';
import thunk from 'redux-thunk';

import './index.css';
import App from './components/App';
import playerApp from './reducers';
import registerServiceWorker from './registerServiceWorker';

let store = createStore(playerApp, applyMiddleware(thunk));

function fetchGames() {
  return fetch('http://no-borders.lvh.me:3000/api/games').then(response =>
    response.json()
  );
}

function loadGames(games) {
  return {
    type: 'LOAD',
    games: games
  };
}

function loadApp() {
  return function(dispatch) {
    return fetchGames().then(games => dispatch(loadGames(games)));
  };
}

store.dispatch(loadApp());

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
);

registerServiceWorker();
