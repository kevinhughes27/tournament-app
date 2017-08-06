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

export { loadApp };
