import React from 'react'
import PropTypes from 'prop-types'

import XLabels from './XLabels'
import YLabels from './YLabels'
import FieldColumn from './FieldColumn'

import moment from 'moment'
import _map from 'lodash/map'

class Schedule extends React.Component {
  render () {
    const fields = this.props.fields
    const date = moment().format('LL') // init to the earliest start date of any game
    // dropdown will need to indicate other dates with games scheduled easily
    // otherwise you could lose games

    return (
      <div className='schedule-editor'>
        { date }
        <XLabels fields={fields} />
        <div className='body'>
          <YLabels />
          <div className='grid'>
            {_map(fields, (f) => {
              return <FieldColumn key={f.name} fieldId={f.id} date={date}/>
            })}
          </div>
        </div>
      </div>
    )
  }
}

Schedule.propTypes = {
  games: PropTypes.array.isRequired, // this is not used in this component..? Games are fetched from the store in FieldColumn
  fields: PropTypes.array.isRequired
}

export default Schedule
