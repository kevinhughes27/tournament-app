import _filter from 'lodash/filter';

export default function(search, games, options = { fuzzy: false }) {
  return options.fuzzy ? fuzzyMatch(search, games) : exactMatch(search, games);
}

/* fuzzy match on home and away team name. returns all games by default */
function fuzzyMatch(search, games) {
  let filteredGames;

  if (search !== '') {
    filteredGames = _filter(games, game => {
      return (
        String(game.home_name).toLowerCase().indexOf(search.toLowerCase()) >=
          0 ||
        String(game.away_name).toLowerCase().indexOf(search.toLowerCase()) >= 0
      );
    });
  } else {
    filteredGames = games;
  }

  return filteredGames;
}

/* exact match home or away team name. returns no games by default */
function exactMatch(teamName, games) {
  let filteredGames = [];

  if (teamName !== '') {
    filteredGames = _filter(games, game => {
      return (
        String(game.home_name).toLowerCase() === teamName.toLowerCase() ||
        String(game.away_name).toLowerCase() === teamName.toLowerCase()
      );
    });
  }

  return filteredGames;
}
