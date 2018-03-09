import { SCHEDULE_START, SCHEDULE_END } from './Constants'
import moment from 'moment'
import 'moment-range'

class GameLayout {
  constructor (game) {
    this.game = game
  }

  inlineStyles () {
    const startTime = moment(this.game.start_time)
    const endTime = moment(this.game.end_time)

    // this is the number of minutes in the day not shown at
    // the begining of the rendered schedule.
    const startOffset = SCHEDULE_START * 60

    // the start and end of the game measured in minutes from the top of the row
    let start = startTime.hour() * 60 + startTime.minutes() - startOffset
    let end = endTime.hour() * 60 + endTime.minutes() - startOffset

    const inday = (SCHEDULE_END - SCHEDULE_START) * 60

    const top = ((start / inday) * 100).toFixed(2) + '%'
    const bottom = (100 - ((end / inday) * 100)).toFixed(2) + '%'
    const position = 'absolute'

    return { top, bottom, position }
  }
}

module.exports = GameLayout
