import client from '../modules/apollo';
import gql from 'graphql-tag';

const query = gql`
  query {
    settings {
      protectScoreSubmit
    }
    map {
      lat
      long
      zoom
    }
    games(scheduled: true, hasTeam: true) {
      id
      homeName
      awayName
      startTime
      endTime
      field {
        id
        name
      }
      homeScore
      awayScore
      scoreConfirmed
    }
    fields {
      id
      name
      lat
      long
      geoJson
    }
    teams {
      id
      name
    }
  }
`;

function loadApp() {
  return dispatch =>
    client
      .query({ query: query })
      .then(response =>
        dispatch({ type: 'LOAD_COMPLETED', response: response })
      )
      .catch(error => dispatch({ type: 'LOAD__FAILED', error }));
}

export { loadApp };
