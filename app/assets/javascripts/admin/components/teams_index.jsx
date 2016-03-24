var React = require('react'),
    Griddle = require('griddle-react'),
    FilterBar = require('../mixins/filter_bar'),
    FilterFunction = require('../mixins/filter_function'),
    TeamsStore = require('../stores/teams_store');

var columns = [
  "id",
  "name",
  "email",
  "sms",
  "division",
  "seed"
];

// these lose their values on sort. need to store this state
var SelectCell = React.createClass({
  render() {
    var teamId = this.props.data;
    return <input type="checkbox" className="bulkCheck" value={teamId} />;
  }
});

var SelectCellHeader = React.createClass({
  getInitialState() {
    return {
      allChecked: false
    }
  },

  _selectAll() {
    var allChecked = !this.state.allChecked;
    this.setState({ allChecked: allChecked });
    $('.bulkCheck').prop('checked', allChecked);
  },

  render() {
    return <input type='checkbox' onClick={this._selectAll} />;
  }
});

var LinkCell = React.createClass({
  render() {
    var team = this.props.rowData;
    var url = "teams/" + team.id;
    return <a href={url}>{this.props.data}</a>;
  }
});

var columnsMeta = [
  {
    columnName: "id",
    order: 1,
    cssClassName: "col-md-1",
    customComponent: SelectCell,
    customHeaderComponent: SelectCellHeader,
    sortable: false
  },
  {
    columnName: "name",
    displayName: "Name",
    cssClassName: "table-link",
    order: 2,
    customComponent: LinkCell
  },
  {
    columnName: "email",
    displayName: "Email",
    cssClassName: 'hidden-xs',
    order: 3,
    sortable: false
  },
  {
    columnName: "sms",
    displayName: "SMS",
    cssClassName: 'hidden-xs',
    order: 4,
    sortable: false
  },
  {
    columnName: "division",
    displayName: "Division",
    cssClassName: "table-link",
    order: 5
  },
  {
    columnName: "seed",
    displayName: "Seed",
    cssClassName: "table-link",
    order: 6
  },
];

var TeamsIndex = React.createClass({
  mixins: [FilterFunction],

  getInitialState() {
    var teams = JSON.parse(this.props.teams);
    TeamsStore.init(teams);

    this.searchColumns = this.props.searchColumns;

    this.teamsFilter = React.createClass({
      mixins: [FilterBar],
      filters: this.props.filters,
      bulkOperations: this.props.bulkOperations,
      render() { return this.renderBar() }
    });

    return {
      teams: TeamsStore.all(),
    };
  },

  componentDidMount() {
    TeamsStore.addChangeListener(this._onChange);
  },

  componentWillUnmount() {
    TeamsStore.removeChangeListener(this._onChange);
  },

  _onChange() {
    this.setState({ teams: TeamsStore.all() });
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
        customFilterComponent={this.teamsFilter}
      />
    );
  }
});

module.exports = TeamsIndex;
