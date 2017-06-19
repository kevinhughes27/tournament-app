import React from 'react'
import PropTypes from 'prop-types'
import GameLayout from './GameLayout'

class GameCell extends React.Component {
  render () {
    const layout = new GameLayout(this.props.game)
    const content = this.props.game.home_name + ' vs ' + this.props.game.away_name

    return (
      <div className='game' style={layout.inlineStyles()}>
        <div className='body'>
          {content}
        </div>
      </div>
    )
  }
}

GameCell.propTypes = {
  game: PropTypes.object.isRequired
}

module.exports = GameCell
