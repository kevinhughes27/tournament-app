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
      return {
        ...state,
        loading: false,
        games: action.json.data.games,
        fields: action.json.data.fields
      };
    // do something better here
    case 'LOAD_FAILED':
      return {
        ...state,
        loading: true
      };
    case 'SET_SEARCH':
      return {
        ...state,
        search: action.value
      };
    default:
      return state;
  }
};
