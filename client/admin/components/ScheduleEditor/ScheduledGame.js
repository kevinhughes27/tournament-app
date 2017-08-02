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
  constructor (props) {
    super(props)
    this.onMouseDown = this.onMouseDown.bind(this)
  }

  onMouseDown (ev) {
    let game = this.props.game
    const bounds = this.refs.game.getBoundingClientRect()

    if (bounds.bottom - ev.clientY < 10) {
      this.props.startResize(game)
      ev.preventDefault()
    }
  }

  render () {
    const { connectDragSource, isDragging, endResize, game } = this.props
    const layout = new GameLayout(game)
    const classes = classNames('game', {error: game.error})
    const color = DIVISION_COLORS[game.division_id % 12]
    const style = {
      opacity: isDragging ? 0.75 : 1,
      backgroundColor: color,
      ...layout.inlineStyles()
    }

    return connectDragSource(
      <div className={classes} style={style}
        onMouseDown={this.onMouseDown}
        onMouseUp={endResize}>
        <div ref='game' className='body'>
          {GameText(game)}
        </div>
      </div>
    )
  }
}

Game.propTypes = {
  game: PropTypes.object.isRequired,
  connectDragSource: PropTypes.func.isRequired,
  isDragging: PropTypes.bool.isRequired,
  startResize: PropTypes.func.isRequired,
  endResize: PropTypes.func.isRequired
}

export default DragSource(ItemTypes.GAME, gameSource, collect)(Game)
