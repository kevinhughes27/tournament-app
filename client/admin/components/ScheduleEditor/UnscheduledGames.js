import React from 'react'
import PropTypes from 'prop-types'
import {Tabs, Tab} from 'react-bootstrap'

import _keys from 'lodash/keys'
import _groupBy from 'lodash/groupBy'
import _map from 'lodash/map'

import Game from './Game'

class UnscheduledGames extends React.Component {
  constructor (props) {
    super(props)

    this.renderDivisionTab = this.renderDivisionTab.bind(this)
    this.renderStage = this.renderStage.bind(this)
    this.renderGamesRow = this.renderGamesRow.bind(this)
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
        {this.renderStage('pool', poolRounds, poolGamesByRound)}
        {this.renderStage('bracket', bracketRounds, bracketGamesByRound)}
      </Tab>
    )
  }

  renderStage (type, rounds, games) {
    return (
      <div>
        {_map(rounds, (round) => {
          return this.renderGamesRow(type, round, games[round])
        })}
      </div>
    )
  }

  renderGamesRow (stage, round, games) {
    return (
      <div key={stage + round} style={{display: 'flex'}}>
        {_map(games, (g) => {
          return <Game key={g.id} game={g}/>
        })}
      </div>
    )
  }
}

UnscheduledGames.propTypes = {
  games: PropTypes.array.isRequired
}

module.exports = UnscheduledGames
