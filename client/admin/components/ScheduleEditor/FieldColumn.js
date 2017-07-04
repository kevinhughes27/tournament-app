import React from 'react'
import PropTypes from 'prop-types'

import ScheduledGame from './ScheduledGame'
import TimeSlot from './TimeSlot'

import GamesStore from '../../stores/GamesStore'
import moment from 'moment'
import _sortBy from 'lodash/sortBy'
import _map from 'lodash/map'

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
          <TimeSlot fieldId={fieldId} startTime={9}/>
        </div>
      </div>
    )
  }
}

FieldColumn.propTypes = {
  fieldId: PropTypes.number.isRequired
}

module.exports = FieldColumn
