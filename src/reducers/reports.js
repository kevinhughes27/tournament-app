const initialState = {
  reports: []
};

export default (state = initialState, action) => {
  switch (action.type) {
    case 'SCORE_REPORT_SUBMITTED':
      return state;

    case 'SCORE_REPORT_RECIEVED':
      return state;

    case 'SCORE_REPORT_FAILED':
      return state;

    default:
      return state;
  }
};
