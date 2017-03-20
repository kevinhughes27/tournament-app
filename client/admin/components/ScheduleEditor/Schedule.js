import React from 'react'

class Schedule extends React.Component {
  render () {
    let fields = this.fields

    return (
      <div style={{display: 'flex'}}>
        Schedule
      </div>
    )
  }
}

Schedule.propTypes = {
  games: React.PropTypes.array.isRequired,
  fields: React.PropTypes.array.isRequired
}

module.exports = Schedule
