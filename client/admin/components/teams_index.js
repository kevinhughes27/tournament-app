import React from 'react';
import ReactDOM from 'react-dom';
import Griddle from 'griddle-react';
import FilterBar from './filter_bar';
import filterFunction from '../modules/filter_function';
import LinkCell from './link_cell';
import TeamsStore from '../stores/teams_store';

const columns = [
  "id",
  "name",
  "email",
  "phone",
  "division",
  "seed"
];

let SelectCell = React.createClass({
  handleChange(ev) {
    let team = this.props.rowData;
    let selected = ev.target.checked;
    TeamsStore.saveSelectedState(team, selected);
  },

  render() {
    let teamId = this.props.data;
    let selected = this.props.rowData.selected;

    return (
      <input
        type="checkbox"
        className="bulkCheck"
        value={teamId}
        checked={selected}
        onChange={this.handleChange} />
    );
  }
});

let SelectCellHeader = React.createClass({
  getInitialState() {
    return {
      allChecked: false
    }
  },

  _selectAll() {
    let allChecked = !this.state.allChecked;
    this.setState({ allChecked: allChecked });
    TeamsStore.setSelected(allChecked);
  },

  render() {
    return <input type='checkbox' onClick={this._selectAll} />;
  }
});

const columnsMeta = [
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
    columnName: "phone",
    displayName: "Phone",
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

let TeamsIndex = React.createClass({

  getInitialState() {
    let teams = JSON.parse(this.props.teams);
    TeamsStore.init(teams);

    this.searchColumns = this.props.searchColumns;
    this.filterFunction = filterFunction.bind(this);

    this.teamsFilter = React.createClass({
      mixins: [FilterBar],
      filters: this.props.filters,
      bulkActions: this.props.bulkActions,
      componentDidMount() { TeamsStore.addChangeListener(this._onChange) },
      componentWillUnmount() { TeamsStore.removeChangeListener(this._onChange) },
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
    let teams = this.state.teams;

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
