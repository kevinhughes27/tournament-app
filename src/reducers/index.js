export default (
  state = {
    loading: true,
    search: '',
    games: []
  },
  action
) => {
  switch (action.type) {
    case 'LOAD_GAMES':
      return {
        ...state,
        games: action.json
      };
    case 'LOAD_GAMES_FAILED':
      return {
        ...state,
        games: action.json
      };
    case 'LOAD_FIELDS':
      return {
        ...state,
        fields: action.json
      };
    case 'LOAD_FIELDS_FAILED':
      return {
        ...state,
        fields: action.json
      };
    case 'LOAD_COMPLETED':
      return {
        ...state,
        loading: false
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
