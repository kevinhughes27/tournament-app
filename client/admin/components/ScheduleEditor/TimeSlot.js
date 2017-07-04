import React from 'react'
import PropTypes from 'prop-types'
import { DropTarget } from 'react-dnd'
import { ItemTypes } from './Constants'

const target = {
  drop (props, monitor, component) {
    const game = monitor.getItem()
    const { fieldId, startTime } = props

    $.ajax({
      type: 'POST',
      url: '/schedule',
      data: {
        games: [
          { id: game.id, field_id: fieldId, start_time: startTime }
        ]
      },
      success: () => { debugger }
    })
  }
}

function collect (connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget(),
    isOver: monitor.isOver()
  }
}

class TimeSlot extends React.Component {
  render () {
    const { connectDropTarget, isOver } = this.props

    const style = {
      opacity: isOver ? 0.5 : 0,
      backgroundColor: 'black',
      minHeight: '10px',
      cursor: 'move'
    }

    return connectDropTarget(
      <div style={style}></div>
    )
  }
}

TimeSlot.propTypes = {
  fieldId: PropTypes.number.isRequired,
  startTime: PropTypes.number.isRequired,
  connectDropTarget: PropTypes.func.isRequired,
  isOver: PropTypes.bool.isRequired
}

module.exports = DropTarget(ItemTypes.GAME, target, collect)(TimeSlot)
