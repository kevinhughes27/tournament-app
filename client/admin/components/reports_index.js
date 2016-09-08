import React from 'react';
import ReactDOM from 'react-dom';
import Griddle from 'griddle-react';
import FilterBar from '../mixins/filter_bar';
import filterFunction from '../modules/filter_function';
import ReportsStore from '../stores/reports_store';

const columns = [
  "name",
  "division",
  "avg",
  "total"
];

const columnsMeta = [
  {
    columnName: "name",
    displayName: "Name",
    cssClassName: "col-md-3",
    order: 1,
  },
  {
    columnName: "division",
    displayName: "Division",
    cssClassName: "col-md-3",
    order: 2,
  },
  {
    columnName: "avg",
    displayName: "Average",
    cssClassName: "col-md-3",
    order: 3,
  },
  {
    columnName: "total",
    displayName: "Total",
    cssClassName: "col-md-3",
    order: 4,
  }
];

let ReportsIndex = React.createClass({

  getInitialState() {
    let reports = JSON.parse(this.props.reports);
    ReportsStore.init(reports);

    this.searchColumns = this.props.searchColumns;
    this.filterFunction = filterFunction.bind(this);

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
    let reports = this.state.reports;

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
