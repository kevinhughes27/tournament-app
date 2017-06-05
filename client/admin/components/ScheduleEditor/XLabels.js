import React from 'react'
import _map from 'lodash/map'

class XLabels extends React.Component {
  render () {
    let labels = _map(this.props.fields, (field) => {
      return (
        <div key={field.name} className='day-label' style={{minWidth: '60px'}}>
          {field.name}
        </div>
      )
    })

    return (
      <div className='x-labels'>
        {labels}
      </div>
    )
  }
}

XLabels.propTypes = {
  fields: React.PropTypes.array.isRequired
}

module.exports = XLabels
