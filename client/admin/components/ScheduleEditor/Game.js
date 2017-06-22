import React from 'react'
import PropTypes from 'prop-types'

class Game extends React.Component {
  constructor (props) {
    super(props)
    this.content = this.content.bind(this)
  }

  render () {
    const style = {
      width: '65px',
      height: '60px',
      margin: '5px',
      border: '1px solid',
      backgroundColor: '#a6cee3',
      textAlign: 'center'
    }

    return (
      <div style={style}>
        {this.content()}
      </div>
    )
  }

  content () {
    const game = this.props.game

    if (game.bracket) {
      return (
        <div>
          <h4>{game.bracket_uid}</h4>
          {game.home_prereq} v {game.away_prereq}
        </div>
      )
    } else {
      return (
        <div>
        <h4>{game.pool}</h4>
        {game.home_pool_seed} v {game.away_pool_seed}
        </div>
      )
    }
  }
}

Game.propTypes = {
  game: PropTypes.object.isRequired
}

module.exports = Game
