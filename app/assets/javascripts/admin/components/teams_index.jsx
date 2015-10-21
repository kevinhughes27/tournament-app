var React = require('react'),
    Griddle = require('griddle-react'),
    TeamsStore = require('../stores/teams_store');

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
    cssClassName: "table-link",
    order: 1
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

var TeamsIndex = React.createClass({
  getInitialState() {
    TeamsStore.init(this.props.teams);

    return {
      teams: TeamsStore.all(),
    };
  },

  rowClick(event) {
    debugger
    console.log(event.props.data);
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
        onRowClick={this.rowClick}
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
