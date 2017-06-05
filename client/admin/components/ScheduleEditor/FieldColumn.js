import React from 'react'
import GameCell from './GameCell'
import GamesStore from '../../stores/GamesStore'
import moment from 'moment'
import _sortBy from 'lodash/sortBy'
import _map from 'lodash/map'

class FieldColumn extends React.Component {
  render () {
    const fieldId = this.props.fieldId
    const games = _sortBy(GamesStore.forField(fieldId), (g) => moment(g.start_time))

    return (
      <div className='day' style={{minWidth: '60px'}}>
        <div key="events" ref="events" className="events">
          {_map(games, (g) => {
            return <GameCell key={g.id} game={g}/>
          })}
        </div>
      </div>
    )
  }
}

FieldColumn.propTypes = {
  fieldId: React.PropTypes.number.isRequired
}

module.exports = FieldColumn
