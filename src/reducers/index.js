export default (
  state = {
    loading: true,
    search: '',
    games: []
  },
  action
) => {
  switch (action.type) {
    case 'LOAD':
      return {
        ...state,
        loading: false,
        games: action.games
      };
    case 'SET_SEARCH':
      return {
        ...state,
        search: action.value.toLowerCase()
      };
    default:
      return state;
  }
};
