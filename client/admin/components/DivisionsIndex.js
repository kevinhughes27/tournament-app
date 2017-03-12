import React from 'react'
import IndexBase from './IndexBase'
import FilterBar from './FilterBar'
import filterFunction from '../modules/FilterFunction'
import LinkCell from './LinkCell'
import DivisionsStore from '../stores/DivisionsStore'

class DivisionsIndex extends IndexBase {
  constructor (props) {
    super(props)

    let divisions = JSON.parse(this.props.divisions)
    DivisionsStore.init(divisions)

    this.filterFunction = filterFunction.bind(this)
    this.buildFilterComponent(FilterBar, DivisionsStore)

    this.state = { items: DivisionsStore.all() }
  }
}

class TeamsCell extends React.Component {
  render () {
    let division = this.props.rowData
    let teamCount = division.teams_count
    let numTeams = division.num_teams
    let color

    if (teamCount === numTeams) {
      color = 'green'
    } else if (teamCount > numTeams) {
      color = 'orange'
    } else {
      color = '#008B8B'
    }

    return (
      <span style={{color: color}}>
        {teamCount} / {numTeams}
      </span>
    )
  }
}

class SeededCell extends React.Component {
  render () {
    let division = this.props.rowData
    let seeded = division.seeded
    let dirtySeed = division.dirty_seed

    let iconClass
    let iconColor

    if (seeded && !dirtySeed) {
      iconClass = 'fa fa-check'
      iconColor = 'green'
    } else if (!seeded) {
      iconClass = 'fa fa-times'
      iconColor = 'orange'
    } else {
      iconClass = 'fa fa-exclamation-circle'
      iconColor = 'orange'
    }

    return (
      <i className={iconClass} style={{color: iconColor}}></i>
    )
  }
}

DivisionsIndex.columns = [
  'name',
  'bracket',
  'teams_count',
  'seeded'
]

DivisionsIndex.columnsMeta = [
  {
    columnName: 'name',
    displayName: 'Name',
    cssClassName: 'table-link',
    order: 1,
    customComponent: LinkCell
  },
  {
    columnName: 'bracket',
    displayName: 'Bracket',
    order: 2
  },
  {
    columnName: 'teams_count',
    displayName: 'Teams',
    order: 3,
    customComponent: TeamsCell
  },
  {
    columnName: 'seeded',
    displayName: 'Seeded',
    order: 4,
    customComponent: SeededCell
  }
]

module.exports = DivisionsIndex
