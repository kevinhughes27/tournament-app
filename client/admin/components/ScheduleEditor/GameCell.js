import React from 'react'
import GameLayout from './GameLayout'

class GameCell extends React.Component {
  render () {
    const layout = new GameLayout(this.props.game)
    const content = this.props.game.home_name + ' vs ' + this.props.game.away_name

    return (
      <div
        ref="element"
        onMouseDown={this.onDragStart}
        style={layout.inlineStyles()}
        className={layout.classNames()}
      >
        <div className="evbody">
          {content}
        </div>
      </div>
    )
  }
}

GameCell.propTypes = {
  game: React.PropTypes.object.isRequired
}

module.exports = GameCell
