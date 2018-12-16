import Settings from '../Settings';
import * as moment from 'moment';

class Position {
  startTime: moment.Moment;
  endTime: moment.Moment;

  constructor(startTime: string, length: number) {
    this.startTime = moment.parseZone(startTime);
    this.endTime = moment.parseZone(startTime).add(length, 'minutes');
  }

  inlineStyles() {
    const startTime = this.startTime;
    const endTime = this.endTime;

    // this is the number of minutes in the day not shown at
    // the begining of the rendered schedule.
    const startOffset = Settings.scheduleStart * 60;

    // the start and end of the game measured in minutes from the top of the row
    const start = startTime.hour() * 60 + startTime.minutes() - startOffset;
    const end = endTime.hour() * 60 + endTime.minutes() - startOffset;

    const inday = Settings.scheduleLength() * 60;

    const top = ((start / inday) * 100).toFixed(2) + '%';
    const bottom = (100 - (end / inday) * 100).toFixed(2) + '%';
    const position = 'absolute' as 'absolute';

    return { top, bottom, position };
  }
}

export default Position;
