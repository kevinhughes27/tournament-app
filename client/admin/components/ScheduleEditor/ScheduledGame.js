import React from 'react'
import PropTypes from 'prop-types'
import { DragSource } from 'react-dnd'
import { ItemTypes, DIVISION_COLORS } from './Constants'
import GameLayout from './GameLayout'
import GameText from './GameText'
import classNames from 'classnames'
import { unschedule } from './Actions'

const gameSource = {
  beginDrag (props) {
    return props.game
  },

  endDrag (props, monitor) {
    if (!monitor.didDrop()) {
      unschedule(props.game.id)
    }
  }
}

function collect (connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  }
}

class Game extends React.Component {
  render () {
    const { connectDragSource, isDragging, game } = this.props
    const layout = new GameLayout(game)
    const classes = classNames('game', {error: game.error})
    const color = DIVISION_COLORS[game.division_id % 12]
    const style = {
      opacity: isDragging ? 0.75 : 1,
      backgroundColor: color,
      cursor: 'move',
      ...layout.inlineStyles()
    }

    return connectDragSource(
      <div className={classes} style={style}>
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
