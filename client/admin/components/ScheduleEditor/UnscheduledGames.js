import React from 'react'
import PropTypes from 'prop-types'
import {Tabs, Tab} from 'react-bootstrap'

import _keys from 'lodash/keys'
import _groupBy from 'lodash/groupBy'
import _sortBy from 'lodash/sortBy'
import _map from 'lodash/map'

import UnscheduledGame from './UnscheduledGame'
import { DIVISION_COLORS } from './Constants'

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
      <div className='nav-tabs-custom'>
        <Tabs id='divisions'>
          {_map(gameByDivision, this.renderDivisionTab)}
        </Tabs>
      </div>
    )
  }

  renderDivisionTab (games, divisionName) {
    let divisionId = games[0].division_id
    let color = DIVISION_COLORS[divisionId % 12]

    let poolGames = games.filter((g) => { return g.pool })
    let bracketGames = games.filter((g) => { return g.bracket })

    let poolGamesByRound = _groupBy(poolGames, 'round')
    let poolRounds = _sortBy(_keys(poolGamesByRound), r => parseInt(r))

    let bracketGamesByRound = _groupBy(bracketGames, 'round')
    let bracketRounds = _sortBy(_keys(bracketGamesByRound), r => parseInt(r))

    let title = <span>
      <i className='fa fa-stop' style={{color: color}}></i> {divisionName}
    </span>

    return (
      <Tab key={divisionName} eventKey={divisionName} title={title}>
        <div className='unscheduled'>
          {this.renderStage('pool', poolRounds, poolGamesByRound)}
          {this.renderStage('bracket', bracketRounds, bracketGamesByRound)}
        </div>
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
          return <UnscheduledGame key={g.id} game={g}/>
        })}
      </div>
    )
  }
}

UnscheduledGames.propTypes = {
  games: PropTypes.array
}

module.exports = UnscheduledGames
