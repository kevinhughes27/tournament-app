import React from 'react'
import Griddle from 'griddle-react'

class IndexBase extends React.Component {
  buildFilterComponent(baseComponent, store) {
    this.filterComponent = React.createClass({
      mixins: [baseComponent],
      filters: this.props.filters,
      bulkActions: this.props.bulkActions || [],
      componentDidMount () { store.addChangeListener(this.filterChange) },
      componentWillUnmount () { store.removeChangeListener(this.filterChange) },
      render () { return this.renderBar() }
    })
  }

  render () {
    let results = this.state.items
    let columns = this.constructor.columns
    let columnsMeta = this.constructor.columnsMeta
    let rowMetadata = this.constructor.rowMetadata
    let filterFunction = this.filterFunction
    let filterComponent = this.filterComponent

    return (
      <Griddle
        results={results}
        tableClassName="table table-striped table-hover"
        columns={columns}
        columnMetadata={columnsMeta}
        rowMetadata={rowMetadata}
        resultsPerPage={results.length}
        showPager={false}
        useGriddleStyles={false}
        sortAscendingClassName="sort asc"
        sortAscendingComponent=""
        sortDescendingClassName="sort desc"
        sortDescendingComponent=""
        showFilter={true}
        useCustomFilterer={true}
        customFilterer={filterFunction}
        useCustomFilterComponent={true}
        customFilterComponent={filterComponent}
      />
    )
  }
}

module.exports = IndexBase
