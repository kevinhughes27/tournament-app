import client from '../modules/apollo';
import gql from 'graphql-tag';

const mutation = gql`
  mutation submitScore($input: SubmitScoreInput!) {
    submitScore(input: $input) {
      success
      gameId
    }
  }
`;

function submitScore(payload) {
  return dispatch => {
    dispatch({ type: 'SCORE_REPORT_SUBMITTED', report: payload });

    return client
      .mutate({ mutation: mutation, variables: { input: payload } })
      .then(response =>
        dispatch({
          type: 'SCORE_REPORT_RECIEVED',
          response: response.data.submitScore
        })
      )
      .catch(error => dispatch({ type: 'SCORE_REPORT_FAILED', gameId: payload.gameId }));
  };
}

export { submitScore };
