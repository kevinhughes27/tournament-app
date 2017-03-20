import React from 'react'
import FieldColumn from './FieldColumn'
import moment from 'moment'
import _map from 'lodash/map'
import _each from 'lodash/each'
import _range from 'lodash/range'

class Schedule extends React.Component {
  render () {
    let fields = this.props.fields

    // needs a min height for some reason.
    return (
      <div className={'dayz week'} style={{minHeight: '400px'}}>
        {this.renderXLabels(fields)}
        <div className='body'>
          {this.renderYLabels()}
          <div className='days'>
            {_map(fields, (f) => {
              return <FieldColumn key={f.name} field={f}/>
            })}
          </div>
        </div>
      </div>
    )
  }

  renderXLabels (fields) {
    let labels = _map(fields, (field) => {
      return (
        <div key={field.name} className="day-label">
          {field.name}
        </div>
      )
    })

    return (
      <div className='x-labels'>
        {labels}
      </div>
    )
  }

  renderYLabels () {
    let day = moment()
    let labels = []
    let hours = _range(9, 17)

    _each(hours, (hour) => {
      day.hour(hour)
      labels.push(<div key={hour} className='hour'>{day.format('ha')}</div>)
    })

    return (
      <div>
        <div className='y-labels'>
          {labels}
        </div>
      </div>
    )
  }
}

Schedule.propTypes = {
  games: React.PropTypes.array.isRequired,
  fields: React.PropTypes.array.isRequired
}

module.exports = Schedule
