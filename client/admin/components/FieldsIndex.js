import IndexBase from './IndexBase'
import FilterBar from './FilterBar'
import filterFunction from '../modules/FilterFunction'
import LinkCell from './LinkCell'
import FieldsStore from '../stores/FieldsStore'

class FieldsIndex extends IndexBase {
  constructor (props) {
    super(props)

    let fields = JSON.parse(this.props.fields)
    FieldsStore.init(fields)

    this.filterFunction = filterFunction.bind(this)
    this.buildFilterComponent(FilterBar, FieldsStore)

    this.state = { items: FieldsStore.all() }
  }
}

FieldsIndex.columns = [
  'name',
  'lat',
  'long'
]

FieldsIndex.columnsMeta = [
  {
    columnName: 'name',
    displayName: 'Name',
    cssClassName: 'table-link',
    order: 1,
    customComponent: LinkCell
  },
  {
    columnName: 'lat',
    displayName: 'Latitude',
    order: 2,
    sortable: false
  },
  {
    columnName: 'long',
    displayName: 'Longitude',
    order: 3,
    sortable: false
  }
]

module.exports = FieldsIndex
