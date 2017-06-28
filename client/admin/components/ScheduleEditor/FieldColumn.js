import React from 'react'
import PropTypes from 'prop-types'

import ScheduledGame from './ScheduledGame'
import GamesStore from '../../stores/GamesStore'
import moment from 'moment'
import _sortBy from 'lodash/sortBy'
import _map from 'lodash/map'

class FieldColumn extends React.Component {
  render () {
    const fieldId = this.props.fieldId
    const games = _sortBy(GamesStore.forField(fieldId), (g) => moment(g.start_time))

    return (
      <div className='field-column' onClick={(ev) => this.handleClick(ev)}>
        <div className='games'>
          {_map(games, (g) => {
            return <ScheduledGame key={g.id} game={g}/>
          })}
        </div>
      </div>
    )
  }

  handleClick (ev) {
    let startTime = '9:00' // convert ev.clientY to startTime
    this.props.onClick.call(startTime)
  }
}

FieldColumn.propTypes = {
  fieldId: PropTypes.number.isRequired,
  onClick: PropTypes.func.isRequired
}

module.exports = FieldColumn
