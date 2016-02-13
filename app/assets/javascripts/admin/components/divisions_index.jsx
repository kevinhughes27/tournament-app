var React = require('react'),
    Griddle = require('griddle-react'),
    FilterBar = require('../mixins/filter_bar'),
    FilterFunction = require('../mixins/filter_function'),
    DivisionsStore = require('../stores/divisions_store');

var columns = [
  "name",
  "bracket",
  "teams",
  "seeded"
];

var LinkCell = React.createClass({
  render() {
    var division = this.props.rowData;
    var url = "divisions/" + division.id;
    return <a href={url}>{this.props.data}</a>;
  }
});

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
    var iconClass;
    var iconColor;

    if(division.seeded) {
      iconClass = "fa fa-check";
      iconColor = "green";
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
    columnName: "teams",
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
