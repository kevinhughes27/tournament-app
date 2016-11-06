import React, { PropTypes, Component } from 'react'
import GamesStore from '../stores/games_store';

export default class TimeSlot extends Component {
  static propTypes = {
    value: PropTypes.instanceOf(Date).isRequired,
    field: PropTypes.number,
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
      <div style={style} onClick={() => this.handleClick()}>
      {this.props.showLabel &&
        <span>{this.props.content}</span>
      }
      </div>
    )
  }

  handleClick() {
    let startTime = this.props.value
    let field = this.props.field
    let gamedId = GamesStore.unscheduledGames()[0].id

    $.ajax({
      type: 'PUT',
      url: '/admin/schedule',
      data: {
        game_id: gamedId,
        field_id: field,
        start_time: startTime
      }
    })
  }
}
