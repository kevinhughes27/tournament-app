import React from 'react';
import ReactDOM from 'react-dom';
import Griddle from 'griddle-react';
import FilterBar from './filter_bar';
import filterFunction from '../modules/filter_function';
import LinkCell from './link_cell';
import DivisionsStore from '../stores/divisions_store';

const columns = [
  "name",
  "bracket",
  "teams_count",
  "seeded"
];

class TeamsCell extends React.Component {
  render() {
    let division = this.props.rowData;
    let teamCount = division.teams_count;
    let numTeams = division.num_teams;
    let color;

    if(teamCount == numTeams) {
      color = "green";
    } else if(teamCount > numTeams) {
      color = 'orange';
    } else {
      color ="#008B8B";
    };

    return (
      <span style={{color: color}}>
        {teamCount} / {numTeams}
      </span>
    );
  }
}

class SeededCell extends React.Component {
  render() {
    let division = this.props.rowData;
    let seeded = division.seeded;
    let dirtySeed = division.dirty_seed;

    let iconClass;
    let iconColor;

    if(seeded && !dirtySeed) {
      iconClass = "fa fa-check";
      iconColor = "green";
    } else if(!seeded) {
      iconClass = "fa fa-times";
      iconColor = 'orange';
    } else {
      iconClass = "fa fa-exclamation-circle";
      iconColor = 'orange';
    };

    return (
      <i className={iconClass} style={{color: iconColor}}></i>
    );
  }
}


const columnsMeta = [
  {
    columnName: "name",
    displayName: "Name",
    cssClassName: "table-link",
    order: 1,
    customComponent: LinkCell
  },
  {
    columnName: "bracket",
    displayName: "Bracket",
    order: 2,
  },
  {
    columnName: "teams_count",
    displayName: "Teams",
    order: 3,
    customComponent: TeamsCell
  },
  {
    columnName: "seeded",
    displayName: "Seeded",
    order: 4,
    customComponent: SeededCell
  }
];

class DivisionsIndex extends React.Component {
  constructor(props) {
    super(props);

    let divisions = JSON.parse(this.props.divisions);
    DivisionsStore.init(divisions);

    this.filterFunction = filterFunction.bind(this);

    this.divisionsFilter = React.createClass({
      mixins: [FilterBar],
      filters: this.props.filters,
      bulkActions: [],
      render() { return this.renderBar() }
    });

    this.state = { divisions: DivisionsStore.all() };
  }

  render() {
    let divisions = this.state.divisions;

    return (
      <Griddle
        results={divisions}
        tableClassName="table table-striped table-hover"
        columns={columns}
        columnMetadata={columnsMeta}
        resultsPerPage={divisions.length}
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
        customFilterComponent={this.divisionsFilter}
      />
    );
  }
}

module.exports = DivisionsIndex;
