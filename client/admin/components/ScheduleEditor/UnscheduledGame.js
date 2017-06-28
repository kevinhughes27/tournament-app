import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { DragSource } from 'react-dnd'
import { ItemTypes } from './Constants'
import GameText from './GameText'

const gameSource = {
  beginDrag (props) {
    return props.game
  }
}

function collect (connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  }
}

class Game extends Component {
  render () {
    const { connectDragSource, isDragging, game } = this.props
    const style = {
      opacity: isDragging ? 0.5 : 1,
      cursor: 'move'
    }

    return connectDragSource(
      <div className='unscheduled-game' style={style}>
        <div className='body'>
          {GameText(game)}
        </div>
      </div>
    )
  }
}

Game.propTypes = {
  game: PropTypes.object.isRequired,
  connectDragSource: PropTypes.func.isRequired,
  isDragging: PropTypes.bool.isRequired
}

export default DragSource(ItemTypes.GAME, gameSource, collect)(Game)
