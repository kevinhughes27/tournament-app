import * as React from "react";
import * as moment from "moment";
import { isEmpty, sortBy, map } from "lodash";

import XLabels from "./XLabels";
import YLabels from "./YLabels";
import FieldColumn from "./FieldColumn";

import DatePicker from "./DatePicker";
import SettingsModal from "./SettingsModal";

interface Props {
  fields: ScheduleEditor_fields;
  games: ScheduledGame[];
}

interface State {
  date: moment.Moment;
}

class Calendar extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);

    if (!isEmpty(this.props.games)) {
      const firstGame = sortBy(this.props.games, (g) => moment(g.startTime))[0];
      const firstDate = moment(firstGame.startTime);
      this.state = {date: firstDate};
    } else {
      const today = moment();
      this.state = {date: today};
    }
  }

  handleDateChange = (date: moment.Moment) => {
    this.setState({date});
  }

  render() {
    const fields = this.props.fields;

    return (
      <div className="schedule">
        {this.renderControls()}
        <XLabels fields={fields} />
        <div className="body">
          <YLabels />
          <div className="grid">
            {map(fields, this.renderColumn)}
          </div>
        </div>
      </div>
    );
  }

  renderControls = () => {
    const { games } = this.props;
    const dates = map(games, (g: any) => moment(g.startTime));
    const date = this.state.date;

    const style = {
      display: "flex",
      justifyContent: "space-between",
      alignItems: "center"
    };

    return (
      <div style={style}>
        <DatePicker
          selected={date}
          highlightDates={dates}
          onChange={this.handleDateChange}
        />
        <SettingsModal onUpdate={() => this.forceUpdate()} />
      </div>
    );
  }

  renderColumn = (field: any) => {
    const date = this.state.date;
    const dateStr = date.format("LL");
    const games = this.props.games.filter((g) => g.field && g.field.id === field.id);

    return (
      <FieldColumn
        key={field.name}
        date={dateStr}
        fieldId={field.id}
        games={games}
      />
    );
  }
}

export default Calendar;
