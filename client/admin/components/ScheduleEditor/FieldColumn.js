import React from 'react'
import PropTypes from 'prop-types'
import { DropTarget } from 'react-dnd'
import ScheduledGame from './ScheduledGame'
import DropOverlay from './DropOverlay'
import TimeSlot from './TimeSlot'
import GamesStore from '../../stores/GamesStore'

import {
  ItemTypes,
  SCHEDULE_START,
  SCHEDULE_END,
  SCHEDULE_INC
} from './Constants'

import moment from 'moment'
import _sortBy from 'lodash/sortBy'
import _map from 'lodash/map'
import _times from 'lodash/times'

const target = {
  drop (props, monitor, component) {
    const game = monitor.getItem()
    const fieldId = props.fieldId
    const startTime = component.state.hoverTime

    GamesStore.updateGame({
      id: game.id,
      field_id: fieldId,
      start_time: startTime,
      scheduled: true
    })

    $.ajax({
      type: 'POST',
      url: '/admin/schedule',
      data: {
        game_id: game.id, field_id: fieldId, start_time: startTime
      },
      success: (response) => {
        GamesStore.updateGame({id: game.id, error: false})
        console.log(`game_id: ${game.id} successfully scheduled.`)
      },
      error: (response) => {
        GamesStore.updateGame({id: game.id, error: true})

        if (response.status === 422) {
          Admin.Flash.error(response.responseJSON.error)
        } else {
          Admin.Flash.error('Sorry, something went wrong.')
        }
      }
    })
  }
}

function collect (connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget(),
    isOver: monitor.isOver()
  }
}

class FieldColumn extends React.Component {
  constructor (props) {
    super(props)
    this.hover = this.hover.bind(this)
    this.state = { hoverTime: null }
  }

  hover (startTime) {
    this.setState({hoverTime: startTime})
  }

  render () {
    const connectDropTarget = this.props.connectDropTarget
    const games = _sortBy(this.props.games, (g) => moment(g.start_time))

    return connectDropTarget(
      <div className='field-column'>
        <div className='games'>
          {_map(games, (g) => {
            return <ScheduledGame key={g.id} game={g}/>
          })}
          { this.overlay() }
          { this.slots() }
        </div>
      </div>
    )
  }

  overlay () {
    if (!this.props.isOver) {
      return
    }

    const start = this.state.hoverTime
    const end = moment(start).add(90, 'minutes').format()
    return (
      <DropOverlay startTime={start} endTime={end}/>
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
        hover={this.hover}
        fieldId={fieldId}
        startTime={startTime}
        height={slotHeight} />
    })
  }
}

FieldColumn.propTypes = {
  connectDropTarget: PropTypes.func.isRequired,
  isOver: PropTypes.bool.isRequired,
  fieldId: PropTypes.number.isRequired,
  games: PropTypes.array.isRequired,
  date: PropTypes.string.isRequired
}

module.exports = DropTarget(ItemTypes.GAME, target, collect)(FieldColumn)
