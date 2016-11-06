import React, { PropTypes, Component } from 'react'

export default class TimeSlot extends Component {
  static propTypes = {
    value: PropTypes.instanceOf(Date).isRequired,
    isNow: PropTypes.bool,
    showLabel: PropTypes.bool,
    content: PropTypes.string,
    rowHeight: PropTypes.number,
  }

  render() {
    let style = {
      height: this.props.rowHeight,
      paddingTop: '5px',
      borderBottom: '1px dashed #DDD'
    }

    return (
      <div style={style} >
      {this.props.showLabel &&
        <span>{this.props.content}</span>
      }
      </div>
    )
  }
}
