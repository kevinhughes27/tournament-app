import React from 'react';
import ReactDOM from 'react-dom';
import IndexBase from './index_base';
import LinkCell from './link_cell';
import TeamsFilterBar from './teams_filter_bar';
import filterFunction from '../modules/filter_function';
import TeamsStore from '../stores/teams_store';

class TeamsIndex extends IndexBase {
  constructor(props) {
    super(props);

    let teams = JSON.parse(this.props.teams);
    TeamsStore.init(teams);

    this.onChange = this.onChange.bind(this);
    this.filterFunction = filterFunction.bind(this);
    this.buildFilterComponent(TeamsFilterBar, TeamsStore);

    this.state = { items: TeamsStore.all() };
  }

  componentDidMount() {
    TeamsStore.addChangeListener(this.onChange);
  }

  componentWillUnmount() {
    TeamsStore.removeChangeListener(this.onChange);
  }

  onChange() {
    this.setState({ items: TeamsStore.all() });
  }
}

class SelectCell extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(ev) {
    let team = this.props.rowData;
    let selected = ev.target.checked;
    TeamsStore.saveSelectedState(team, selected);
  }

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
}

class SelectCellHeader extends React.Component {
  constructor(props) {
    super(props);
    this.selectAll = this.selectAll.bind(this);
    this.state = { allChecked: false };
  }

  selectAll() {
    let allChecked = !this.state.allChecked;
    this.setState({ allChecked: allChecked });
    TeamsStore.setSelected(allChecked);
  }

  render() {
    return <input type='checkbox' onClick={this.selectAll} />;
  }
}

TeamsIndex.columns = [
  "id",
  "name",
  "email",
  "phone",
  "division",
  "seed"
];

TeamsIndex.columnsMeta = [
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

module.exports = TeamsIndex;
