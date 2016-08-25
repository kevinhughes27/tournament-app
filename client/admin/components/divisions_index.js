var React = require('react'),
    ReactDOM = require('react-dom'),
    Griddle = require('griddle-react'),
    FilterBar = require('../mixins/filter_bar'),
    FilterFunction = require('../mixins/filter_function'),
    LinkCell = require('./link_cell'),
    DivisionsStore = require('../stores/divisions_store');

var columns = [
  "name",
  "bracket",
  "teams_count",
  "seeded"
];

var TeamsCell = React.createClass({
  render() {
    var division = this.props.rowData;
    var teamCount = division.teams_count;
    var numTeams = division.num_teams;
    var color;

    if(teamCount == numTeams) {
      color = "green";
    } else if(teamCount > numTeams) {
      color = 'orange';
    } else {
      color ="#008B8B";
    };

    return (
      <span style={{color: color}}>
        {teamCount} / {numTeams}
      </span>
    );
  }
});

var SeededCell = React.createClass({
  render() {
    var division = this.props.rowData;
    var seeded = division.seeded;
    var dirtySeed = division.dirty_seed;

    var iconClass;
    var iconColor;

    if(seeded && !dirtySeed) {
      iconClass = "fa fa-check";
      iconColor = "green";
    } else if(!seeded) {
      iconClass = "fa fa-times";
      iconColor = 'orange';
    } else {
      iconClass = "fa fa-exclamation-circle";
      iconColor = 'orange';
    };

    return (
      <i className={iconClass} style={{color: iconColor}}></i>
    );
  }
});


var columnsMeta = [
  {
    columnName: "name",
    displayName: "Name",
    cssClassName: "table-link",
    order: 1,
    customComponent: LinkCell
  },
  {
    columnName: "bracket",
    displayName: "Bracket",
    order: 2,
  },
  {
    columnName: "teams_count",
    displayName: "Teams",
    order: 3,
    customComponent: TeamsCell
  },
  {
    columnName: "seeded",
    displayName: "Seeded",
    order: 4,
    customComponent: SeededCell
  }
];

var DivisionsIndex = React.createClass({
  mixins: [FilterFunction],

  getInitialState() {
    var divisions = JSON.parse(this.props.divisions);
    DivisionsStore.init(divisions);

    this.searchColumns = this.props.searchColumns;

    this.divisionsFilter = React.createClass({
      mixins: [FilterBar],
      filters: this.props.filters,
      bulkActions: [],
      render() { return this.renderBar() }
    });

    return {
      divisions: DivisionsStore.all(),
    };
  },

  render() {
    var divisions = this.state.divisions;

    return (
      <Griddle
        results={divisions}
        tableClassName="table table-striped table-hover"
        columns={columns}
        columnMetadata={columnsMeta}
        resultsPerPage={divisions.length}
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
        customFilterComponent={this.divisionsFilter}
      />
    );
  }
});

module.exports = DivisionsIndex;