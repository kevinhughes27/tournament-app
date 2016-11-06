import moment from 'moment'
import dateMath from 'date-arithmetic';
import React, { PropTypes, Component } from 'react'
import TimeSlot from './time_slot'

export default class TimeSlotGroup extends Component {
  static propTypes = {
    value: PropTypes.instanceOf(Date).isRequired,
    field: PropTypes.number,
    step: PropTypes.number.isRequired,
    timeslots: PropTypes.number.isRequired,
    rowHeight: PropTypes.number,
    isNow: PropTypes.bool,
    showLabels: PropTypes.bool,
    timeGutterFormat: PropTypes.string,

  }

  renderSlice(slotNumber, content, value) {
    return <TimeSlot key={slotNumber}
                     showLabel={this.props.showLabels && !slotNumber}
                     content={content}
                     rowHeight={this.props.rowHeight}
                     isNow={this.props.isNow}
                     field={this.props.field}
                     value={value} />
  }

  renderSlices() {
    const ret = []
    const sliceLength = this.props.step
    let sliceValue = this.props.value
    for (let i = 0; i < this.props.timeslots; i++) {
      const content = moment(sliceValue).format(this.props.timeGutterFormat)
      ret.push(this.renderSlice(i, content, sliceValue))
      sliceValue = dateMath.add(sliceValue, sliceLength , 'minutes')
    }
    return ret
  }

  render() {
    let style = {borderBottom: '1px solid #DDD'}

    return (
      <div style={style}>
        {this.renderSlices()}
      </div>
    )
  }
}
