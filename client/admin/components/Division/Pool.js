import React from 'react'
import PropTypes from 'prop-types'

class Pool extends React.Component {
  renderGamesLink (divisionName, pool) {
    return (
      <div className='pull-right subdued' style={{fontSize: '10px'}}>
        <a href={`/admin/games?division=${divisionName}&pool=${pool}`}>
          Games <i className="fa fa-external-link"></i>
        </a>
      </div>
    )
  }

  renderHeader (divisionName, pool) {
    return (
      <thead>
        <tr>
          <th>
            Pool {pool}
            {divisionName ? this.renderGamesLink(divisionName, pool) : null}
          </th>
        </tr>
      </thead>
    )
  }

  renderRow (team) {
    let text = team.seed
    if (team.name && team.name !== team.seed) {
      text = `${team.seed} - ${team.name}`
    }

    return (
      <tr key={team.seed}>
        <td>{text}</td>
      </tr>
    )
  }

  render () {
    let {pool, teams, divisionName} = this.props

    return (
      <div style={{minWidth: '140px', marginLeft: '20px', marginRight: '20px'}}>
        <table className="table table-bordered table-striped table-hover table-condensed">
          {this.renderHeader(divisionName, pool)}
          <tbody>
            { teams.map(this.renderRow)}
          </tbody>
        </table>
      </div>
    )
  }
}

Pool.propTypes = {
  pool: PropTypes.string,
  teams: PropTypes.array,
  divisionName: PropTypes.string
}

module.exports = Pool
