import React from 'react'
import PropTypes from 'prop-types'
import { DragSource } from 'react-dnd'
import { ItemTypes, DIVISION_COLORS } from './Constants'
import GameLayout from './GameLayout'
import GameText from './GameText'
import classNames from 'classnames'
import GamesStore from '../../stores/GamesStore'

const gameSource = {
  beginDrag (props) {
    return props.game
  },

  endDrag (props, monitor) {
    const game = props.game

    if (!monitor.didDrop()) {
      GamesStore.updateGame({id: game.id, scheduled: false})

      $.ajax({
        type: 'DELETE',
        url: '/admin/schedule',
        data: { game_id: game.id },
        success: (response) => {
          console.log(`game_id: ${game.id} successfully unscheduled.`)
        },
        error: (response) => {
          GamesStore.updateGame({id: game.id, scheduled: true})
          Admin.Flash.error('Sorry, something went wrong.')
        }
      })
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
