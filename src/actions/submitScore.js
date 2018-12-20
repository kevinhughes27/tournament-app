import client from '../apollo';
import gql from 'graphql-tag';

const mutation = gql`
  mutation submitScore($input: SubmitScoreInput!) {
    submitScore(input: $input) {
      success
    }
  }
`;

function submitScore(payload) {
  return dispatch => {
    dispatch({ type: 'SCORE_REPORT_SUBMITTED', report: payload });

    return client
      .mutate({ mutation: mutation, variables: { input: payload } })
      .then(response =>
        dispatch({ type: 'SCORE_REPORT_RECIEVED', response: response })
      )
      .catch(error => dispatch({ type: 'SCORE_REPORT_FAILED', error }));
  };
}

export { submitScore };
