import React from 'react';
import ReactDOM from 'react-dom';
import IndexBase from './index_base';
import FilterBar from './filter_bar';
import filterFunction from '../modules/filter_function';
import ReportsStore from '../stores/reports_store';

class ReportsIndex extends IndexBase {
  constructor(props) {
    super(props);

    let reports = JSON.parse(this.props.reports);
    ReportsStore.init(reports);

    this.onChange = this.onChange.bind(this);
    this.filterFunction = filterFunction.bind(this);
    this.buildFilterComponent(FilterBar, ReportsStore);

    this.state = { items: ReportsStore.all() };
  }

  componentDidMount() {
    ReportsStore.addChangeListener(this.onChange);
  }

  componentWillUnmount() {
    ReportsStore.removeChangeListener(this.onChange);
  }

  onChange() {
    this.setState({ items: ReportsStore.all() });
  }
}

ReportsIndex.columns = [
  "name",
  "division",
  "avg",
  "total"
];

ReportsIndex.columnsMeta = [
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

module.exports = ReportsIndex;
