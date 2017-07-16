import React from 'react'
import PropTypes from 'prop-types'

import XLabels from './XLabels'
import YLabels from './YLabels'
import FieldColumn from './FieldColumn'
import DatePicker from 'react-datepicker'

import moment from 'moment'
import _map from 'lodash/map'
import _filter from 'lodash/filter'
import _isEmpty from 'lodash/isEmpty'

class Schedule extends React.Component {
  constructor (props) {
    super(props)

    let date = moment()
    if (!_isEmpty(this.props.games)) {
      date = moment(this.props.games[0].start_time)
    }

    this.state = {date: date}

    this.handleDateChange = this.handleDateChange.bind(this)
  }

  handleDateChange (date) {
    this.setState({date: date})
  }

  render () {
    const { games, fields, gameLength } = this.props
    const dates = _map(games, (g) => moment(g.start_time))

    const date = this.state.date
    const dateString = date.format('LL')

    return (
      <div className='schedule'>
        <div className='form-group' style={{width: '160px'}}>
          <DatePicker
            className='form-control'
            selected={date}
            onChange={this.handleDateChange}
            highlightDates={dates}
          />
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
                date={dateString}
                gameLength={gameLength}/>
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
  fields: PropTypes.array.isRequired,
  gameLength: PropTypes.number.isRequired
}

export default Schedule
