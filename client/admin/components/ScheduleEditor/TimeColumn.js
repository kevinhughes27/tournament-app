import dateMath from 'date-arithmetic'

import React, { Component, PropTypes } from 'react'
import TimeSlotGroup from './TimeSlotGroup'

export default class TimeColumn extends Component {
  static propTypes = {
    title: PropTypes.string,
    field: PropTypes.number,
    step: PropTypes.number.isRequired,
    timeslots: PropTypes.number.isRequired,
    rowHeight: PropTypes.number.isRequired,
    now: PropTypes.instanceOf(Date).isRequired,
    min: PropTypes.instanceOf(Date).isRequired,
    max: PropTypes.instanceOf(Date).isRequired,
    showLabels: PropTypes.bool,
    timeGutterFormat: PropTypes.string,
  }

  static defaultProps = {
    showLabels: false,
    timeGutterFormat: 'hh:mm A'
  }

  renderTimeSliceGroup(key, isNow, date) {
    return (
      <TimeSlotGroup
        key={key}
        field={this.props.field}
        isNow={isNow}
        timeslots={this.props.timeslots}
        step={this.props.step}
        showLabels={this.props.showLabels}
        timeGutterFormat={this.props.timeGutterFormat}
        rowHeight={this.props.rowHeight}
        value={date}
      />
    )
  }

  render() {
    const totalMin = dateMath.diff(this.props.min, this.props.max, 'minutes')
    const numGroups = Math.ceil(totalMin / (this.props.step * this.props.timeslots))
    const timeslots = []
    const groupLengthInMinutes = this.props.step * this.props.timeslots

    let date = this.props.min
    let next = date
    let isNow = false

    for (var i = 0; i < numGroups; i++) {
     isNow = dateMath.inRange(
          this.props.now
        , date
        , dateMath.add(next, groupLengthInMinutes - 1, 'minutes')
        , 'minutes'
      )
      next = dateMath.add(date, groupLengthInMinutes, 'minutes');
      timeslots.push(this.renderTimeSliceGroup(i, isNow, date))

      date = next
    }

    return (
      <div style={{minWidth: this.props.colWidth, borderRight: '1px solid #DDD'}}>
        <div style={{minHeight: '25px', textAlign: 'center', paddingBottom: '5px', borderBottom: '1px solid #DDD'}}>
          {this.props.title}
        </div>
        {timeslots}
        {this.props.children}
      </div>
    )
  }
}
