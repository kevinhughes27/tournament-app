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
      url: '/admin/schedule',
      data: {
        game_id: game.id, field_id: fieldId, start_time: startTime
      },
      success: (response) => { debugger },
      error: (response) => { debugger }
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
    const { connectDropTarget, isOver, height } = this.props

    const style = {
      opacity: isOver ? 0.5 : 0,
      backgroundColor: 'black',
      height: height
    }

    return connectDropTarget(
      <div style={style}></div>
    )
  }
}

TimeSlot.propTypes = {
  fieldId: PropTypes.number.isRequired,
  startTime: PropTypes.string.isRequired,
  height: PropTypes.string.isRequired,
  connectDropTarget: PropTypes.func.isRequired,
  isOver: PropTypes.bool.isRequired
}

module.exports = DropTarget(ItemTypes.GAME, target, collect)(TimeSlot)
