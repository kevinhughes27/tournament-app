import React from 'react'
import PropTypes from 'prop-types'
import _map from 'lodash/map'

class XLabels extends React.Component {
  render () {
    let labels = _map(this.props.fields, (field) => {
      return (
        <div key={field.name} className='x-label'>
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
  fields: PropTypes.array.isRequired
}

module.exports = XLabels