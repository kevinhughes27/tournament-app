import IndexBase from '../IndexBase'
import FilterBar from '../FilterBar'
import filterFunction from '../../modules/FilterFunction'
import _some from 'lodash/some'
import {NameCell, ScoreCell} from './Row'
import GamesStore from '../../stores/GamesStore'

class GamesIndex extends IndexBase {
  constructor (props) {
    super(props)

    let games = JSON.parse(this.props.games)
    GamesStore.init(games)

    this.onChange = this.onChange.bind(this)
    this.filterFunction = filterFunction.bind(this)
    this.buildFilterComponent(FilterBar, GamesStore)

    this.state = { items: GamesStore.all() }
  }

  componentDidMount () {
    GamesStore.addChangeListener(this.onChange)
  }

  componentWillUnmount () {
    GamesStore.removeChangeListener(this.onChange)
  }

  onChange () {
    this.setState({ items: GamesStore.all() })
  }
}

GamesIndex.columns = [
  'home_name',
  'division',
  'pool',
  'confirmed'
]

GamesIndex.columnsMeta = [
  {
    columnName: 'home_name',
    displayName: 'Game',
    cssClassName: 'col-md-6 table-link',
    order: 1,
    customComponent: NameCell
  },
  {
    columnName: 'division',
    displayName: 'Division',
    cssClassName: 'col-md-1 table-link',
    order: 2
  },
  {
    columnName: 'pool',
    displayName: 'Pool',
    cssClassName: 'col-md-1 table-link',
    order: 3
  },
  {
    columnName: 'confirmed',
    displayName: 'Score',
    cssClassName: 'col-md-1',
    order: 4,
    sortable: false,
    customComponent: ScoreCell
  }
]

GamesIndex.rowMetadata = {
  bodyCssClassName: function (rowData) {
    let game = rowData
    let sotgWarning = _some(game.score_reports, function (report) { return report.sotg_warning })

    if (sotgWarning) {
      return 'warning'
    }

    return 'default-row'
  }
}

module.exports = GamesIndex
