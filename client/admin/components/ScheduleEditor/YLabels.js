import React from 'react'
import moment from 'moment'
import _each from 'lodash/each'
import _range from 'lodash/range'

class YLabels extends React.Component {
  render () {
    let day = moment()
    let labels = []
    let hours = _range(9, 17)

    _each(hours, (hour) => {
      day.hour(hour)
      labels.push(<div key={hour} className='y-label'>{day.format('ha')}</div>)
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

module.exports = YLabels
