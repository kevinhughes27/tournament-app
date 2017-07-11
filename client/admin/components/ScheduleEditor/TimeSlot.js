import React from 'react'
import PropTypes from 'prop-types'
import { DropTarget } from 'react-dnd'
import { ItemTypes } from './Constants'

const target = {
  hover (props) {
    const startTime = props.startTime
    props.hover(startTime)
  }
}

function collect (connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget()
  }
}

class TimeSlot extends React.Component {
  render () {
    const { connectDropTarget, height } = this.props

    return connectDropTarget(
      <div style={{height: height}}></div>
    )
  }
}

TimeSlot.propTypes = {
  connectDropTarget: PropTypes.func.isRequired,
  hover: PropTypes.func.isRequired,
  height: PropTypes.string.isRequired,
  fieldId: PropTypes.number.isRequired,
  startTime: PropTypes.string.isRequired
}

module.exports = DropTarget(ItemTypes.GAME, target, collect)(TimeSlot)
