import React from 'react'
import PropTypes from 'prop-types'

import XLabels from './XLabels'
import YLabels from './YLabels'
import FieldColumn from './FieldColumn'

import moment from 'moment'
import _map from 'lodash/map'
import _filter from 'lodash/filter'

class Schedule extends React.Component {
  constructor (props) {
    super(props)
    this.state = {date: moment()}

    this.handleDateChange = this.handleDateChange.bind(this)
  }

  handleDateChange (event) {
    this.setState({date: moment(event.target.value, 'LL')})
  }

  render () {
    const fields = this.props.fields
    const date = this.state.date
    const dateString = date.format('LL')

    return (
      <div className='schedule-editor'>
        <div className='form-group' style={{width: '160px'}}>
          <input type='text' className='form-control' value={dateString} onChange={this.handleDateChange}/>
        </div>
        <XLabels fields={fields} />
        <div className='body'>
          <YLabels />
          <div className='grid'>
            {_map(fields, (f) => {
              return <FieldColumn
                key={f.name}
                fieldId={f.id}
                games={this.gamesForField(f.id)}
                date={dateString}/>
            })}
          </div>
        </div>
      </div>
    )
  }

  gamesForField (fieldId) {
    const games = this.props.games
    return _filter(games, (g) => g.field_id === fieldId)
  }
}

Schedule.propTypes = {
  games: PropTypes.array,
  fields: PropTypes.array.isRequired
}

export default Schedule
