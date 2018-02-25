import IndexBase from './IndexBase'
import FilterBar from './FilterBar'
import filterFunction from '../modules/FilterFunction'
import ReportsStore from '../stores/ReportsStore'

class ReportsIndex extends IndexBase {
  constructor (props) {
    super(props)

    let reports = JSON.parse(this.props.reports)
    ReportsStore.init(reports)

    this.onChange = this.onChange.bind(this)
    this.filterFunction = filterFunction.bind(this)
    this.buildFilterComponent(FilterBar, ReportsStore)

    this.state = { items: ReportsStore.all() }
  }

  componentDidMount () {
    ReportsStore.addChangeListener(this.onChange)
  }

  componentWillUnmount () {
    ReportsStore.removeChangeListener(this.onChange)
  }

  onChange () {
    this.setState({ items: ReportsStore.all() })
  }
}

ReportsIndex.columns = [
  'name',
  'division',
  'avg',
  'total'
]

ReportsIndex.columnsMeta = [
  {
    columnName: 'name',
    displayName: 'Name',
    cssClassName: 'col-md-3',
    order: 1
  },
  {
    columnName: 'division',
    displayName: 'Division',
    cssClassName: 'col-md-3',
    order: 2
  },
  {
    columnName: 'avg',
    displayName: 'Average',
    cssClassName: 'col-md-3',
    order: 3
  },
  {
    columnName: 'total',
    displayName: 'Total',
    cssClassName: 'col-md-3',
    order: 4
  }
]

module.exports = ReportsIndex
