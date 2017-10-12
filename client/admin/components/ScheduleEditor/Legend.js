import React from 'react'
import PropTypes from 'prop-types'
import _map from 'lodash/map'
import _groupBy from 'lodash/groupBy'

import { DIVISION_COLORS } from './Constants'

class Legend extends React.Component {
  render () {
    let games = this.props.games
    let gameByDivision = _groupBy(games, 'division')

    return (
      <div className='box box-solid'>
        <div className='box-body'>
          {_map(gameByDivision, (games, divisionName) => {
            let divisionId = games[0].division_id
            let color = DIVISION_COLORS[divisionId % 12]

            return (
              <span key={divisionId}>
                <h4>
                  <i className='fa fa-stop' style={{color: color}}></i> {divisionName}
                </h4>
              </span>
            )
          })}
        </div>
      </div>
    )
  }
}

Legend.propTypes = {
  games: PropTypes.array
}

module.exports = Legend
