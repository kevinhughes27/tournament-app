import React from 'react';
import ReactDOM from 'react-dom';
import Griddle from 'griddle-react';
import FilterBar from '../mixins/filter_bar';
import filterFunction from '../modules/filter_function';
import _some from 'lodash/some';
import {NameCell, ScoreCell} from './game';
import GamesStore from '../stores/games_store';

const columns = [
  "name",
  "division",
  "pool",
  "confirmed",
];

const columnsMeta = [
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

let rowMetadata = {
  bodyCssClassName: function(rowData) {
    let game = rowData;
    let sotgWarning = _some(game.score_reports, function(report){ return report.sotg_warning });

    if(sotgWarning) {
      return 'warning';
    }

    return 'default-row';
  }
};

let GamesIndex = React.createClass({

  getInitialState() {
    let games = JSON.parse(this.props.games);
    GamesStore.init(games);

    this.searchColumns = this.props.searchColumns;
    this.filterFunction = filterFunction.bind(this);

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
    let games = this.state.games;

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
