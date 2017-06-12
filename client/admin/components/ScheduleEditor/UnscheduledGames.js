import React from 'react'
import PropTypes from 'prop-types'
import {Tabs, Tab} from 'react-bootstrap'

import _keys from 'lodash/keys'
import _groupBy from 'lodash/groupBy'
import _map from 'lodash/map'

class UnscheduledGames extends React.Component {
  constructor (props) {
    super(props)

    this.renderDivisionTab = this.renderDivisionTab.bind(this)
    this.renderGamesRow = this.renderGamesRow.bind(this)
    this.renderUnscheduledGame = this.renderUnscheduledGame.bind(this)
  }

  render () {
    let games = this.props.games
    let gameByDivision = _groupBy(games, 'division')

    return (
      <div style={{paddingLeft: '5px'}}>
        <Tabs id="divisions">
          {_map(gameByDivision, this.renderDivisionTab)}
        </Tabs>
      </div>
    )
  }

  renderDivisionTab (games, divisionName) {
    let poolGames = games.filter((g) => { return g.pool })
    let bracketGames = games.filter((g) => { return g.bracket })

    let poolGamesByRound = _groupBy(poolGames, 'round')
    let poolRounds = _keys(poolGamesByRound).sort()

    let bracketGamesByRound = _groupBy(bracketGames, 'round')
    let bracketRounds = _keys(bracketGamesByRound).sort()

    return (
      <Tab key={divisionName} eventKey={divisionName} title={divisionName}>
        {_map(poolRounds, (round) => {
          return this.renderGamesRow('pool', round, poolGamesByRound[round])
        })}
        {_map(bracketRounds, (round) => {
          return this.renderGamesRow('bracket', round, bracketGamesByRound[round])
        })}
      </Tab>
    )
  }

  renderGamesRow (stage, round, games) {
    return (
      <div key={stage + round} style={{display: 'flex'}}>
        {_map(games, this.renderUnscheduledGame)}
      </div>
    )
  }

  renderUnscheduledGame (game) {
    let style = {
      width: '65px',
      height: '60px',
      margin: '5px',
      border: '1px solid',
      backgroundColor: '#a6cee3',
      textAlign: 'center'
    }

    return (
      <div key={game.id} style={style} draggable>
        {this.renderGameText(game)}
      </div>
    )
  }

  renderGameText (game) {
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

UnscheduledGames.propTypes = {
  games: PropTypes.array.isRequired
}

module.exports = UnscheduledGames
