import React from 'react'
import PropTypes from 'prop-types'
import { DropTarget } from 'react-dnd'
import ScheduledGame from './ScheduledGame'
import DropOverlay from './DropOverlay'
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

const target = {
  hover (props, monitor, component) {
    const rect = component.refs.column.getBoundingClientRect()
    const percentY = (monitor.getClientOffset().y - rect.top) / rect.height
    const hours = percentY * (SCHEDULE_END - SCHEDULE_START) + SCHEDULE_START
    const slot = SCHEDULE_INC * Math.round(hours * 60 / SCHEDULE_INC)
    const hoverTime = moment(props.date).minutes(slot)

    component.setState({
      hoverTime: hoverTime
    })
  },

  drop (props, monitor, component) {
    const game = monitor.getItem()
    const fieldId = props.fieldId
    const startTime = component.state.hoverTime.format()

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
  render () {
    const connectDropTarget = this.props.connectDropTarget
    const games = _sortBy(this.props.games, (g) => moment(g.start_time))

    return connectDropTarget(
      <div className='field-column'>
        <div className='games' ref='column'>
          {_map(games, (g) => {
            return <ScheduledGame key={g.id} game={g}/>
          })}
          { this.overlay() }
        </div>
      </div>
    )
  }

  overlay () {
    if (!this.props.isOver) {
      return
    }

    const start = this.state.hoverTime.format()
    const end = moment(start).add(90, 'minutes').format()

    return (<DropOverlay startTime={start} endTime={end}/>)
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
