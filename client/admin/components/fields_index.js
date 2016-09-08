import React from 'react';
import ReactDOM from 'react-dom';
import Griddle from 'griddle-react';
import FilterBar from './filter_bar';
import filterFunction from '../modules/filter_function';
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

class FieldsIndex extends React.Component {
  constructor(props) {
    super(props);

    let fields = JSON.parse(this.props.fields);
    FieldsStore.init(fields);

    this.filterFunction = filterFunction.bind(this);

    this.fieldsFilter = React.createClass({
      mixins: [FilterBar],
      filters: this.props.filters,
      bulkActions: [],
      render() { return this.renderBar() }
    });

    this.state = { fields: FieldsStore.all() };
  }

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
}

module.exports = FieldsIndex;
