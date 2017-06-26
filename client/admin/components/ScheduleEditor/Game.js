import React from 'react'
import PropTypes from 'prop-types'
import GameText from './GameText'

class Game extends React.Component {
  render () {
    const game = this.props.game

    return (
      <div className='unscheduled-game'>
        <div className='body'>
          {GameText(game)}
        </div>
      </div>
    )
  }
}

Game.propTypes = {
  game: PropTypes.object.isRequired
}

module.exports = Game
