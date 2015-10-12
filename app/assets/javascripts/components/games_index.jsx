var _ = require('underscore'),
    React = require('react'),
    GameRow = require('./game_row');

var GamesIndex = React.createClass({
  getInitialState() {
    return {
      games: this.props.games,
      searchString: '',
      sortBy: '',
      sortReverse: false
    };
  },

  sortUpdated(field) {
    var sortBy, sortReverse;

    if (field == this.state.sortBy) {
      sortReverse = !this.state.sortReverse
    } else {
      sortReverse = false
    };

    var games = this.state.games;

    if (sortReverse) {
      games = _.sortBy(games, field).reverse();
    } else {
      games = _.sortBy(games, field);
    };

    this.setState({
      sortBy: field,
      sortReverse: sortReverse,
      games: games
    });
  },

  searchUpdated(event) {
    var val = event.target.value;
    val = val.replace("\\", "");
    val = val.toLowerCase();
    this.setState({searchString: val});
  },

  searchFilter(games, searchString) {
    return _.filter(games, function(game) {
      return game.name.toLowerCase().match(searchString) ||
             game.home.toLowerCase().match(searchString) ||
             game.away.toLowerCase().match(searchString);
    });
  },

  updateGame(updatedGame) {
    var games = this.state.games;

    var idx = _.findIndex(games, function(game){
      return game.id == updatedGame.id;
    });

    games[idx] = updatedGame;
    this.setState({games: games});
  },

  render() {
    var games = this.state.games;
    var searchString = this.state.searchString;

    if (searchString) {
      games = this.searchFilter(games, searchString);
    };

    return (
      <div>
        <div className="input-group" style={{paddingBottom: '15px'}}>
          <div className="input-group-addon">
            <i className="fa fa-search"></i>
          </div>
          <input className="search form-control"
                 value={searchString}
                 placeholder="Search"
                 onChange={this.searchUpdated}/>
        </div>
        <table className="table table-striped table-hover">
          <thead>
            <tr>
              <th className="sort-header">
                <a href="#" className="sort" onClick={this.sortUpdated.bind(this, "name")}>
                  Game
                </a>
              </th>
              <th className="sort-header">
                <a href="#" className="sort" onClick={this.sortUpdated.bind(this, "division")}>
                  Division
                </a>
              </th>
              <th>Score</th>
              <th className="sort-header">
                <a href="#" className="sort" onClick={this.sortUpdated.bind(this, "confirmed")}>
                  Confirmed
                </a>
              </th>
            </tr>
          </thead>
          <tbody>
            { games.map((game, idx) => {
              return <GameRow key={idx} game={game} gamesIndex={this} />;
            })}
          </tbody>
        </table>
      </div>
    );
  }
});

module.exports = GamesIndex;
