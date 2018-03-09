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

import { schedule, resize } from './Actions'

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
    const endTime = component.state.hoverTime.add(props.gameLength, 'minutes').format()

    schedule(game.id, fieldId, startTime, endTime)
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

    this.startResize = this.startResize.bind(this)
    this.endResize = this.endResize.bind(this)
    this.onMouseMove = this.onMouseMove.bind(this)

    this.state = {
      hoverTime: null,
      resizing: false,
      resizingGame: null
    }
  }

  startResize (game) {
    this.setState({resizing: true, resizingGame: game})
  }

  endResize () {
    if (this.state.resizing) {
      let game = this.state.resizingGame
      schedule(game.id, game.field_id, game.start_time, game.end_time)
    }

    this.setState({resizing: false, resizingGame: null})
  }

  onMouseMove (ev) {
    if (!this.state.resizing) {
      return
    }

    let game = this.state.resizingGame

    const rect = this.refs.column.getBoundingClientRect()
    const percentY = (ev.clientY - rect.top) / rect.height
    const hours = percentY * (SCHEDULE_END - SCHEDULE_START) + SCHEDULE_START
    const slot = SCHEDULE_INC * Math.round(hours * 60 / SCHEDULE_INC)
    const endTime = moment(this.props.date, 'LL').minutes(slot)

    if (moment.duration(endTime.diff(game.start_time)).asMinutes() < SCHEDULE_INC) {
      return
    }

    resize(game.id, endTime.format())
  }

  render () {
    const { connectDropTarget, date, games } = this.props
    const filteredGames = _fitler(games, (g) => moment(date, 'LL').isSame(g.start_time, 'day'))
    const sortedGames = _sortBy(filteredGames, (g) => moment(g.start_time))

    return connectDropTarget(
      <div className='field-column'>
        <div className='games'
          ref='column'
          onMouseMove={this.onMouseMove}
          onMouseLeave={this.endResize}
          onMouseUp={this.endResize}>
          {_map(sortedGames, (g) => {
            return <ScheduledGame
              key={g.id}
              game={g}
              startResize={this.startResize}/>
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
      const length = this.props.gameLength

      return range.contains(this.state.hoverTime) ||
        range.contains(moment(this.state.hoverTime).add(length, 'minutes'))
    })

    if (overlaps) {
      return
    }

    const start = this.state.hoverTime.format()
    const length = this.props.gameLength
    const end = moment(start).add(length, 'minutes').format()

    return (<DropOverlay startTime={start} endTime={end}/>)
  }
}

FieldColumn.propTypes = {
  connectDropTarget: PropTypes.func.isRequired,
  isOver: PropTypes.bool.isRequired,
  fieldId: PropTypes.number.isRequired,
  games: PropTypes.array.isRequired,
  date: PropTypes.string.isRequired,
  gameLength: PropTypes.number.isRequired
}

module.exports = DropTarget(ItemTypes.GAME, target, collect)(FieldColumn)
