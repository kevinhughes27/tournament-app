import React from 'react';
import ReactDOM from 'react-dom';
import IndexBase from './index_base';
import FilterBar from './filter_bar';
import filterFunction from '../modules/filter_function';
import LinkCell from './link_cell';
import FieldsStore from '../stores/fields_store';

class FieldsIndex extends IndexBase {
  constructor(props) {
    super(props);

    let fields = JSON.parse(this.props.fields);
    FieldsStore.init(fields);

    this.filterFunction = filterFunction.bind(this);
    this.buildFilterComponent(FilterBar, FieldsStore);

    this.state = { items: FieldsStore.all() };
  }
}

FieldsIndex.columns = [
  "name",
  "lat",
  "long"
];

FieldsIndex.columnsMeta = [
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

module.exports = FieldsIndex;
