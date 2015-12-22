var React = require('react'),
    Griddle = require('griddle-react'),
    FilterBar = require('./filter_bar'),
    FilterBarMixin = require('../lib/filter_bar_mixin'),
    TeamsStore = require('../stores/teams_store');

var columns = [
  "name",
  "email",
  "sms",
  "division",
  "seed"
];

var searchColumns = [
  "name",
  "email",
  "sms",
  "division",
  "seed"
];

var filterColumns = [
  "division"
];

var LinkCell = React.createClass({
  render() {
    var team = this.props.rowData;
    var url = "teams/" + team.id;
    return <a href={url}>{this.props.data}</a>;
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
    columnName: "email",
    displayName: "Email",
    cssClassName: "table-link",
    order: 2,
    sortable: false
  },
  {
    columnName: "sms",
    displayName: "SMS",
    cssClassName: "table-link",
    order: 3,
    sortable: false
  },
  {
    columnName: "division",
    displayName: "Division",
    cssClassName: "table-link",
    order: 4
  },
  {
    columnName: "seed",
    displayName: "Seed",
    cssClassName: "table-link",
    order: 5
  },
];

class TeamsFilter extends FilterBar {
  filterColumns() { return filterColumns; }
}

var TeamsIndex = React.createClass({
  mixins: [FilterBarMixin],
  searchColumns: searchColumns,

  getInitialState() {
    TeamsStore.init(this.props.teams);

    return {
      teams: TeamsStore.all(),
    };
  },

  render() {
    var teams = this.state.teams;

    return (
      <Griddle
        results={teams}
        tableClassName="table table-striped table-hover"
        columns={columns}
        columnMetadata={columnsMeta}
        resultsPerPage={teams.length}
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
        customFilterComponent={TeamsFilter}
      />
    );
  }
});

module.exports = TeamsIndex;
