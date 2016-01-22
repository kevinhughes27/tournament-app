var React = require('react'),
    Griddle = require('griddle-react'),
    FilterBar = require('../mixins/filter_bar'),
    FilterFunction = require('../mixins/filter_function'),
    FieldsStore = require('../stores/fields_store');

var columns = [
  "name",
  "lat",
  "long"
];

var searchColumns = [
  "name"
];

var filterColumns = [
  "name"
];

var LinkCell = React.createClass({
  render() {
    var field = this.props.rowData;
    var url = "fields/" + field.id;
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
    columnName: "lat",
    displayName: "Latitude",
    cssClassName: "table-link",
    order: 2,
    sortable: false
  },
  {
    columnName: "long",
    displayName: "Longitude",
    cssClassName: "table-link",
    order: 3,
    sortable: false
  }
];

var FieldsFilter = React.createClass({
  mixins: [FilterBar],
  filterColumns: filterColumns,
  render() {
    return this.renderBar()
  }
});

var FieldsIndex = React.createClass({
  mixins: [FilterFunction],
  searchColumns: searchColumns,

  getInitialState() {
    FieldsStore.init(this.props.fields);

    return {
      fields: FieldsStore.all(),
    };
  },

  render() {
    var fields = this.state.fields;

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
        customFilterComponent={FieldsFilter}
      />
    );
  }
});

module.exports = FieldsIndex;
