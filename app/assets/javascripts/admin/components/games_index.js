var React = require('react'),
    ReactDOM = require('react-dom'),
    Griddle = require('griddle-react'),
    FilterBar = require('../mixins/filter_bar'),
    FilterFunction = require('../mixins/filter_function'),
    NameCell = require('./game').NameCell,
    ScoreCell = require('./game').ScoreCell,
    GamesStore = require('../stores/games_store');

var columns = [
  "name",
  "division",
  "pool",
  "confirmed",
];

var columnsMeta = [
  {
    columnName: "name",
    displayName: "Game",
    cssClassName: "col-md-6 table-link",
    order: 1,
    customComponent: NameCell
  },
  {
    columnName: "division",
    displayName: "Division",
    cssClassName: "col-md-1 table-link",
    order: 2,
  },
  {
    columnName: "pool",
    displayName: "Pool",
    cssClassName: "col-md-1 table-link",
    order: 3,
  },
  {
    columnName: "confirmed",
    displayName: "Score",
    cssClassName: "col-md-1",
    order: 4,
    sortable: false,
    customComponent: ScoreCell
  }
];

var rowMetadata = {
  bodyCssClassName: function(rowData) {
    var game = rowData;
    var sotgWarning = _.some(game.score_reports, function(report){ return report.sotg_warning });

    if(sotgWarning) {
      return 'warning';
    }

    return 'default-row';
  }
};

var GamesIndex = React.createClass({
  mixins: [FilterFunction],

  getInitialState() {
    var games = JSON.parse(this.props.games);
    GamesStore.init(games);

    this.searchColumns = this.props.searchColumns;

    this.gamesFilter = React.createClass({
      mixins: [FilterBar],
      filters: this.props.filters,
      bulkActions: [],
      componentDidMount() { GamesStore.addChangeListener(this._onChange) },
      componentWillUnmount() { GamesStore.removeChangeListener(this._onChange) },
      render() { return this.renderBar() }
    });

    return {
      games: GamesStore.all(),
    };
  },

  componentDidMount() {
    GamesStore.addChangeListener(this._onChange);
  },

  componentWillUnmount() {
    GamesStore.removeChangeListener(this._onChange);
  },

  _onChange() {
    this.setState({ games: GamesStore.all() });
  },

  render() {
    var games = this.state.games;

    return (
      <Griddle
        results={games}
        tableClassName="table table-striped table-hover"
        columns={columns}
        columnMetadata={columnsMeta}
        rowMetadata={rowMetadata}
        resultsPerPage={games.length}
        showPager={false}
        useGriddleStyles={false}
        sortAscendingClassName="sort asc"
        sortAscendingComponent=""
        sortDescendingClassName="sort desc"
        sortDescendingComponent=""
        showFilter={true}
        useCustomFilterer={true}
        customFilterer={this.filterFunction}
        useCustomFilterComponent={true}
        customFilterComponent={this.gamesFilter}
      />
    );
  }
});

module.exports = GamesIndex;
