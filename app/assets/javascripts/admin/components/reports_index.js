var React = require('react'),
    Griddle = require('griddle-react'),
    FilterBar = require('../mixins/filter_bar'),
    FilterFunction = require('../mixins/filter_function'),
    ReportsStore = require('../stores/reports_store');

var columns = [
  "name",
  "division",
  "total"
];

var columnsMeta = [
  {
    columnName: "name",
    displayName: "Name",
    cssClassName: "col-md-4",
    order: 1,
  },
  {
    columnName: "division",
    displayName: "Division",
    cssClassName: "col-md-4",
    order: 2,
  },
  {
    columnName: "total",
    displayName: "Total",
    cssClassName: "col-md-4",
    order: 3,
  }
];

var ReportsIndex = React.createClass({
  mixins: [FilterFunction],

  getInitialState() {
    var reports = JSON.parse(this.props.reports);
    ReportsStore.init(reports);

    this.searchColumns = this.props.searchColumns;
    this.reportsFilter = React.createClass({
      mixins: [FilterBar],
      filters: this.props.filters,
      bulkActions: [],
      componentDidMount() { ReportsStore.addChangeListener(this._onChange) },
      componentWillUnmount() { ReportsStore.removeChangeListener(this._onChange) },
      render() { return this.renderBar() }
    });

    return {
      reports: ReportsStore.all(),
    };
  },

  componentDidMount() {
    ReportsStore.addChangeListener(this._onChange);
  },

  componentWillUnmount() {
    ReportsStore.removeChangeListener(this._onChange);
  },

  _onChange() {
    this.setState({ reports: ReportsStore.all() });
  },

  render() {
    var reports = this.state.reports;

    return (
      <Griddle
        results={reports}
        tableClassName="table table-striped table-hover"
        columns={columns}
        columnMetadata={columnsMeta}
        resultsPerPage={reports.length}
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
        customFilterComponent={this.reportsFilter}
      />
    );
  }
});

module.exports = ReportsIndex;
