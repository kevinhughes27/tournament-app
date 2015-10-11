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

  searchUpdated(event) {
    var val = event.target.value;
    val = val.replace("\\", "");
    this.setState({searchString: val});
  },

  searchFilter(games, searchString) {
    return _.filter(games, function(game) {
      return game.name.match(searchString) ||
             game.home.match(searchString) ||
             game.away.match(searchString);
    });
  },

  sortUpdated(field) {
    if(field == this.state.sortBy) {
      this.setState({
        sortBy: field,
        sortReverse: !this.state.sortReverse
      });
    } else {
      this.setState({
        sortBy: field,
        sortReverse: false
      });
    }
  },

  sortFilter(games, field, reverse) {
    if(reverse){
      return _.sortBy(games, field).reverse();
    } else {
      return _.sortBy(games, field);
    }
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
    var sortBy = this.state.sortBy;
    var sortReverse = this.state.sortReverse;

    if(searchString) {
      games = this.searchFilter(games, searchString);
    };

    if(sortBy) {
      games = this.sortFilter(games, sortBy, sortReverse);
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
              return <GameRow gamesIndex={this} gameIdx={idx}/>;
            })}
          </tbody>
        </table>
      </div>
    );
  }
});

module.exports = GamesIndex;
