const initialState = {
  map: null,
  games: [],
  teams: [],
  fields: []
};

export default (state = initialState, action) => {
  switch (action.type) {
    case 'LOAD_COMPLETED':
      const { settings, map, games, fields, teams } = action.response.data;
      return {
        settings: settings,
        map: map,
        games: games,
        fields: fields,
        teams: teams
      };

    case 'LOAD_FAILED':
      return state;

    default:
      return state;
  }
};
