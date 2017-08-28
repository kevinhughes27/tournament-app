export default (
  state = {
    loading: true,
    search: '',
    games: []
  },
  action
) => {
  switch (action.type) {
    case 'LOAD_COMPLETED':
      const { games, fields, teams } = action.json.data;
      return {
        ...state,
        loading: false,
        games: games,
        fields: fields,
        teams: teams
      };
    case 'LOAD_FAILED':
      // do something better here
      return {
        ...state,
        loading: true
      };
    case 'SET_SEARCH':
      return {
        ...state,
        search: action.value
      };
    case 'SCORE_REPORT_SUBMITTED':
      return state;
    case 'SCORE_REPORT_FAILED':
      return state;
    default:
      return state;
  }
};
