import React from 'react'
import PropTypes from 'prop-types'
import GameLayout from './GameLayout'
import GameText from './GameText'

class GameCell extends React.Component {
  render () {
    const game = this.props.game
    const layout = new GameLayout(game)

    return (
      <div className='game' style={layout.inlineStyles()}>
        <div className='body'>
          {GameText(game)}
        </div>
      </div>
    )
  }
}

GameCell.propTypes = {
  game: PropTypes.object.isRequired
}

module.exports = GameCell
