import React from 'react';
import ReactDOM from 'react-dom';
import Griddle from 'griddle-react';
import FilterBar from '../mixins/filter_bar';
import FilterFunction from '../mixins/filter_function';
import LinkCell from './link_cell';
import FieldsStore from '../stores/fields_store';

const columns = [
  "name",
  "lat",
  "long"
];

const columnsMeta = [
  {
    columnName: "name",
    displayName: "Name",
    cssClassName: "table-link",
    order: 1,
    customComponent: LinkCell
  },
  {
    columnName: "lat",
    displayName: "Latitude",
    order: 2,
    sortable: false
  },
  {
    columnName: "long",
    displayName: "Longitude",
    order: 3,
    sortable: false
  }
];

let FieldsIndex = React.createClass({
  mixins: [FilterFunction],

  getInitialState() {
    let fields = JSON.parse(this.props.fields);
    FieldsStore.init(fields);

    this.searchColumns = this.props.searchColumns;

    this.fieldsFilter = React.createClass({
      mixins: [FilterBar],
      filters: this.props.filters,
      bulkActions: [],
      render() { return this.renderBar() }
    });

    return {
      fields: FieldsStore.all(),
    };
  },

  render() {
    let fields = this.state.fields;

    return (
      <Griddle
        results={fields}
        tableClassName="table table-striped table-hover"
        columns={columns}
        columnMetadata={columnsMeta}
        resultsPerPage={fields.length}
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
        customFilterComponent={this.fieldsFilter}
      />
    );
  }
});

module.exports = FieldsIndex;
