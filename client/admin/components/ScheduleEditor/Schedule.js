import React from 'react'
import PropTypes from 'prop-types'

import XLabels from './XLabels'
import YLabels from './YLabels'
import FieldColumn from './FieldColumn'
import _map from 'lodash/map'

class Schedule extends React.Component {
  render () {
    let fields = this.props.fields

    return (
      <div className='schedule-editor'>
        <XLabels fields={fields} />
        <div className='body'>
          <YLabels />
          <div className='grid'>
            {_map(fields, (f) => {
              return <FieldColumn key={f.name} fieldId={f.id}/>
            })}
          </div>
        </div>
      </div>
    )
  }
}

Schedule.propTypes = {
  games: PropTypes.array.isRequired,
  fields: PropTypes.array.isRequired
}

module.exports = Schedule
