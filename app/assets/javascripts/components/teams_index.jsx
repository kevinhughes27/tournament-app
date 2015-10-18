var _ = require('underscore'),
    React = require('react'),
    Griddle = require('griddle-react');

var columns = [
  "name",
  "email",
  "sms",
  "division",
  "seed"
];

var columnsMeta = [
  {
    columnName: "name",
    displayName: "Name",
    cssClassName: "sort-header",
    order: 1
  },
  {
    columnName: "email",
    displayName: "Email",
    cssClassName: "sort-header",
    order: 2,
    sortable: false
  },
  {
    columnName: "sms",
    displayName: "SMS",
    cssClassName: "sort-header",
    order: 3,
    sortable: false
  },
  {
    columnName: "division",
    displayName: "Division",
    cssClassName: "sort-header",
    order: 4
  },
  {
    columnName: "seed",
    displayName: "Seed",
    cssClassName: "sort-header",
    order: 5
  },
];

var TeamsIndex = React.createClass({
  getInitialState() {
    return {
      teams: this.props.teams,
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
        filterPlaceholderText="Search"
      />
    );
  }
});

module.exports = TeamsIndex;
