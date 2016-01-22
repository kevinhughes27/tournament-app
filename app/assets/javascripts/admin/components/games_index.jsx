var React = require('react'),
    Griddle = require('griddle-react'),
    FilterBar = require('../mixins/filter_bar'),
    FilterFunction = require('../mixins/filter_function'),
    NameCell = require('./game').NameCell,
    ScoreCell = require('./game').ScoreCell,
    ConfirmedCell = require('./game').ConfirmedCell,
    GamesStore = require('../stores/games_store');

var columns = [
  "name",
  "division",
  "score",
  "confirmed"
];

var searchColumns = [
  "name",
  "division"
];

var filters = [
  {text: 'Open Division', key: 'division', value: 'Open'},
  {text: 'Womens Division', key: 'division', value: 'Women'},
  {text: 'Coed Comp Division', key: 'division', value: 'Coed Comp'},
  {text: 'Junior Open Division', key: 'division', value: 'Junior Open'},
  {text: 'Has teams', key: 'has_teams', value: 1},
  {text: 'Scores submitted', key: 'has_score_reports', value: 1},
  {text: 'Nothing submitted', key: 'has_score_reports', value: 0},
  {text: 'With score', key: 'has_score', value: 1},
  {text: 'No score', key: 'has_score', value: 0},
  {text: 'Confirmed', key: 'confirmed', value: 1},
  {text: 'Unconfirmed', key: 'confirmed', value: 0},
  {text: 'Finished', key: 'played', value: 1},
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

var GamesFilter = React.createClass({
  mixins: [FilterBar],
  filters: filters,
  render() { return this.renderBar() }
});

var GamesIndex = React.createClass({
  mixins: [FilterFunction],
  searchColumns: searchColumns,

  getInitialState() {
    GamesStore.init(this.props.games);

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
        customFilterComponent={GamesFilter}
      />
    );
  }
});

module.exports = GamesIndex;
