function submitScore(payload) {
  return dispatch =>
    fetch('http://no-borders.lvh.me:3000/graphql', {
      method: 'post',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
      },
      mode: 'cors',
      body: JSON.stringify({
        query: `mutation submitScore($input: SubmitScoreInput!) {
          submitScore(input: $input){
            success
          }
        }`,
        variables: {
          input: payload
        }
      })
    })
      .then(response => response.json())
      .then(
        json => dispatch({ type: 'SCORE_REPORT_SUBMITTED', json }),
        err => dispatch({ type: 'SCORE_REPORT_FAILED', err })
      );
}

export { submitScore };
