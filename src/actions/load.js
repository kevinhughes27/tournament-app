function loadApp() {
  return dispatch =>
    fetch('http://no-borders.lvh.me:3000/graphql', {
      method: 'post',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
      },
      mode: 'cors',
      body: JSON.stringify({
        query: `{ 
        games {
          id
          home_name
          away_name
          start_time
          end_time
          field_name
        }
        fields {
          id
          name
          geo_json
        }
        teams {
          id
          name
        }
      }`
      })
    })
      .then(response => response.json())
      .then(
        json => dispatch({ type: 'LOAD_COMPLETED', json }),
        err => dispatch({ type: 'LOAD__FAILED', err })
      );
}

export { loadApp };
