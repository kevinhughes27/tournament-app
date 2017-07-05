import React from 'react'
import PropTypes from 'prop-types'

import ScheduledGame from './ScheduledGame'
import TimeSlot from './TimeSlot'

import { SCHEDULE_START, SCHEDULE_END, SCHEDULE_INC } from './Constants'

import GamesStore from '../../stores/GamesStore'

import moment from 'moment'
import _sortBy from 'lodash/sortBy'
import _map from 'lodash/map'
import _times from 'lodash/times'

class FieldColumn extends React.Component {
  render () {
    const fieldId = this.props.fieldId
    const games = _sortBy(GamesStore.forField(fieldId), (g) => moment(g.start_time))

    return (
      <div className='field-column'>
        <div className='games'>
          {_map(games, (g) => {
            return <ScheduledGame key={g.id} game={g}/>
          })}
          { this.slots() }
        </div>
      </div>
    )
  }

  slots () {
    const { fieldId, date } = this.props

    const numSlots = (SCHEDULE_END - SCHEDULE_START) * 60 / SCHEDULE_INC
    const slotHeight = `${1.0 / numSlots * 100}%`

    return _times(numSlots, (n) => {
      const startTime = moment(date)
        .hours(SCHEDULE_START)
        .add(n * SCHEDULE_INC, 'minutes')
        .format()

      return <TimeSlot
        key={`${fieldId}:${n}`}
        fieldId={fieldId}
        startTime={startTime}
        height={slotHeight} />
    })
  }
}

FieldColumn.propTypes = {
  fieldId: PropTypes.number.isRequired,
  date: PropTypes.string.isRequired
}

module.exports = FieldColumn
