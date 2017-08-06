const app = (state = {}, action) => {
  switch (action.type) {
    case 'LOAD':
      return {
        ...state,
        loading: false,
        games: action.games
      };
    default:
      return {
        loading: true,
        games: []
      };
  }
};

export default app;
