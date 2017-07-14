import React from 'react'
import PropTypes from 'prop-types'
import { DropTarget } from 'react-dnd'
import ScheduledGame from './ScheduledGame'
import DropOverlay from './DropOverlay'

import {
  ItemTypes,
  SCHEDULE_START,
  SCHEDULE_END,
  SCHEDULE_INC
} from './Constants'

import { schedule } from './Actions'

import moment from 'moment'
import 'moment-range'
import _sortBy from 'lodash/sortBy'
import _fitler from 'lodash/filter'
import _some from 'lodash/some'
import _map from 'lodash/map'

const target = {
  hover (props, monitor, component) {
    const rect = component.refs.column.getBoundingClientRect()
    const percentY = (monitor.getClientOffset().y - rect.top) / rect.height
    const hours = percentY * (SCHEDULE_END - SCHEDULE_START) + SCHEDULE_START
    const slot = SCHEDULE_INC * Math.round(hours * 60 / SCHEDULE_INC)
    const hoverTime = moment(props.date, 'LL').minutes(slot)

    component.setState({
      hoverTime: hoverTime
    })
  },

  drop (props, monitor, component) {
    const game = monitor.getItem()
    const fieldId = props.fieldId
    const startTime = component.state.hoverTime.format()

    schedule(game.id, fieldId, startTime)
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
    const { connectDropTarget, date, games } = this.props
    const filteredGames = _fitler(games, (g) => moment(date).isSame(g.start_time, 'day'))
    const sortedGames = _sortBy(filteredGames, (g) => moment(g.start_time))

    return connectDropTarget(
      <div className='field-column'>
        <div className='games' ref='column'>
          {_map(sortedGames, (g) => {
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

    const overlaps = _some(this.props.games, (g) => {
      const startTime = moment(g.start_time).add(1, 'minute')
      const endTime = moment(g.end_time).subtract(1, 'minute')
      const range = moment().range(startTime, endTime)

      return range.contains(this.state.hoverTime) ||
        range.contains(moment(this.state.hoverTime).add(90, 'minutes'))
    })

    if (overlaps) {
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
