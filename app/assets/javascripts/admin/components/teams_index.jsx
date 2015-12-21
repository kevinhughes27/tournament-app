var _ = require('underscore'),
    squish = require('object-squish'),
    React = require('react'),
    Griddle = require('griddle-react'),
    FilterBar = require('./filter_bar'),
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

var LinkCell = React.createClass({
  render(){
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
  filterColumns() {
    return [
      "division"
    ];
  }
}

var TeamsIndex = React.createClass({
  getInitialState() {
    TeamsStore.init(this.props.teams);

    return {
      teams: TeamsStore.all(),
    };
  },

  filterFunction(results, filter) {
    return _.filter(results, (item) => {
      // filter
      for(key in filter) {
        if(key == 'search') continue;

        if(filter[key]) {
          if(item[key] != filter[key]) {
            return false;
          }
        };
      };

      // search
      var flat = squish(item);
      var search = filter.search;
      if(search) {
        for (var key in flat) {
          if (this._keyNotSearchable(key)) continue;

          if (String(flat[key]).toLowerCase().indexOf(search.toLowerCase()) >= 0) {
            return true;
          };
        };
        return false;
      }

      return true;
    });
  },

  _keyNotSearchable(key) {
    _.indexOf(searchColumns, key) == -1
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
