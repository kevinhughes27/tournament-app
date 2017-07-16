import _filter from 'lodash/filter'
import _groupBy from 'lodash/groupBy'
import _each from 'lodash/each'
import _map from 'lodash/map'
import _unionWith from 'lodash/unionWith'
import _isEqual from 'lodash/isEqual'
import _sortBy from 'lodash/sortBy'
import _keys from 'lodash/keys'

import React from 'react'

import Pool from './Pool'
import BracketVis from './BracketVis'

class Division extends React.Component {
  constructor (props) {
    super(props)

    let bracketHandle = this.props.bracket_handle
    let bracket = BracketDb.find(bracketHandle)

    this.state = {
      bracketHandle: bracketHandle,
      bracket: bracket
    }
  }

  componentDidMount () {
    this.renderBracket()

    $('#division_bracket_type').on('change', (event) => {
      let bracketHandle = $(event.target).val()
      let bracket = BracketDb.find(bracketHandle)

      this.setState({
        bracketHandle: bracketHandle,
        bracket: bracket
      })
    })
  }

  componentDidUpdate () {
    this.renderBracket()
  }

  renderBracket () {
    let node = $('#bracketGraph')
    let bracketVis = new BracketVis(node)

    let bracket = this.state.bracket
    let bracketTree = this.props.bracket_tree

    if (bracket) {
      bracketVis.render(bracket, bracketTree)
    }
  }

  renderDescription (bracket) {
    return (
      <div>
        <p>
          <strong>{bracket.name}</strong>
        </p>
        <p>{bracket.description}</p>
      </div>
    )
  }

  renderPools (bracket) {
    let games = this.props.games ? JSON.parse(this.props.games) : bracket.template.games
    let divisionName = games[0].division

    let teamsByPool = this._teamsByPool(games)
    let pools = _keys(teamsByPool)

    return (
      <div style={{display: 'flex', flexWrap: 'wrap', justifyContent: 'flex-start'}}>
        { pools.map((pool) => {
          return <Pool
            key={pool}
            pool={pool}
            teams={teamsByPool[pool]}
            divisionName={divisionName}
          />
        })}
      </div>
    )
  }

  _teamsByPool (games) {
    let teamsByPool = {}

    let poolGames = _filter(games, 'pool')
    let gamesByPool = _groupBy(poolGames, 'pool')

    _each(gamesByPool, function (poolGames, pool) {
      let homeTeams = _map(poolGames, (g) => {
        return {seed: g.home_prereq, name: g.home_name}
      })

      let awayTeams = _map(poolGames, (g) => {
        return {seed: g.away_prereq, name: g.away_name}
      })

      let teams = _unionWith(homeTeams, awayTeams, _isEqual)
      teamsByPool[pool] = _sortBy(teams, function (t) { return parseInt(t.seed) })
    })

    return teamsByPool
  }

  renderBracketContainer () {
    let divisionName = this.props.division_name

    return (
      <div style={{paddingLeft: '20px', paddingRight: '20px'}}>
        <div className='panel panel-default'>
          <div className='panel-heading' style={{backgroundColor: 'white'}}>
            <strong>Bracket</strong>
            {this.renderGamesLink(divisionName)}
          </div>
          <div className='panel-body'>
            <div style={{height: '440px'}}>
              <div id="bracketGraph" style={{height: '100%'}}></div>
            </div>
          </div>
        </div>
      </div>
    )
  }

  renderGamesLink (divisionName) {
    if (!divisionName) return

    return (
      <div className='pull-right subdued' style={{fontSize: '10px'}}>
        <a href={`/admin/games?division=${divisionName}&bracket=1`}>
          Games <i className="fa fa-external-link"></i>
        </a>
      </div>
    )
  }

  render () {
    let bracket = this.state.bracket

    if (bracket) {
      let hasPools = bracket.pool

      return (
        <div>
          {this.renderDescription(bracket)}
          <hr/>
          { hasPools ? this.renderPools(bracket) : null }
          { this.renderBracketContainer() }
        </div>
      )
    } else {
      return (
        <div>
          No brackets found.
        </div>
      )
    }
  }
}

module.exports = Division
