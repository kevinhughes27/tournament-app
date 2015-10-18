var React = require('react'),
    Griddle = require('griddle-react'),
    NameCell = require('./game').NameCell,
    ScoreCell = require('./game').ScoreCell,
    ConfirmedCell = require('./game').ConfirmedCell;

var columns = [
  "name",
  "division",
  "score",
  "confirmed"
];

var columnsMeta = [
  {
    columnName: "name",
    displayName: "Game",
    cssClassName: "col-md-7 table-link",
    order: 1,
    customComponent: NameCell
  },
  {
    columnName: "division",
    displayName: "Division",
    cssClassName: "col-md-2 table-link",
    order: 2,
  },
  {
    columnName: "score",
    displayName: "Score",
    cssClassName: "col-md-1 table-link",
    order: 3,
    sortable: false,
    customComponent: ScoreCell
  },
  {
    columnName: "confirmed",
    displayName: "Confirmed",
    cssClassName: "col-md-2 table-link",
    order: 4,
    customComponent: ConfirmedCell
  },
];

var GamesIndex = React.createClass({
  getInitialState() {
    return {
      games: this.props.games,
    };
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

    return (
      <Griddle
        results={games}
        tableClassName="table table-striped table-hover"
        columns={columns}
        columnMetadata={columnsMeta}
        resultsPerPage={games.length}
        showPager={false}
        useGriddleStyles={false}
        sortAscendingClassName="sort asc"
        sortAscendingComponent=""
        sortDescendingClassName="sort desc"
        sortDescendingComponent=""
        showFilter={true}
        filterPlaceholderText="Search"
      />
    );
  }
});

module.exports = GamesIndex;
