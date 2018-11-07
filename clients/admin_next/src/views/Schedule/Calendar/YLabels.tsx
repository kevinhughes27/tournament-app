import * as React from "react";
import Settings from "./Settings";
import moment from "moment";
import { each, range } from "lodash";

class YLabels extends React.Component {
  render() {
    const day = moment();
    const labels: any[] = [];
    const hours = range(Settings.scheduleStart, Settings.scheduleEnd);

    each(hours, (hour: number) => {
      day.hour(hour);
      labels.push(<div key={hour} className="y-label">{day.format("ha")}</div>);
    });

    return (
      <div>
        <div className="y-labels">
          {labels}
        </div>
      </div>
    );
  }
}

export default YLabels;
