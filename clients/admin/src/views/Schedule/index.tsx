import * as React from "react";
import { query } from "../../queries/ScheduleEditorQuery";
import renderQuery from "../../helpers/renderQuery";
import ScheduleEditor from "./ScheduleEditor";

class Schedule extends React.Component {
  render() {
    return renderQuery(query, {}, ScheduleEditor);
  }
}

export default Schedule;
