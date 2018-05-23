import ApolloClient from 'apollo-client';
import gql from 'graphql-tag';

const client = new ApolloClient();

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
      home_name
      away_name
      start_time
      end_time
      field_name
      home_score
      away_score
      score_confirmed
    }
    fields {
      id
      name
      lat
      long
      geo_json
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
