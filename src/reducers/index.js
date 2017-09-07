import ls from 'local-storage';
const searchKey = 'search';

export default (
  state = {
    loading: true,
    search: ls.get(searchKey) || '',
    games: []
  },
  action
) => {
  switch (action.type) {
    case 'LOAD_COMPLETED':
      const { map, games, fields, teams } = action.json.data;
      return {
        ...state,
        loading: false,
        map: map,
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
      const search = action.value;
      ls.set(searchKey, search);
      return {
        ...state,
        search: search
      };
    case 'SCORE_REPORT_SUBMITTED':
      return state;
    case 'SCORE_REPORT_FAILED':
      return state;
    default:
      return state;
  }
};
