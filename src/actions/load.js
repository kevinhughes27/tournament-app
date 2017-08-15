function loadGames() {
  return dispatch =>
    fetch('http://no-borders.lvh.me:3000/api/games')
      .then(response => response.json())
      .then(
        json => dispatch({ type: 'LOAD_GAMES', json }),
        err => dispatch({ type: 'LOAD_GAMES_FAILED', err })
      );
}

function loadFields() {
  return dispatch =>
    fetch('http://no-borders.lvh.me:3000/api/fields')
      .then(response => response.json())
      .then(
        json => dispatch({ type: 'LOAD_FIELDS', json }),
        err => dispatch({ type: 'LOAD_FIELDS_FAILED', err })
      );
}

function loadApp() {
  return dispatch =>
    Promise.all([dispatch(loadGames()), dispatch(loadFields())]).then(() => {
      dispatch({ type: 'LOAD_COMPLETED' });
    });
}

export { loadApp };
