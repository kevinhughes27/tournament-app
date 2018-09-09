import * as React from "react";
import Input from "./Input";
import ReactDatePicker from "react-datepicker";

interface Props {
  selected: Date;
  highlightDates: Date[];
  onChange: (date: Date) => void;
}

class DatePicker extends React.Component<Props> {
  render() {
    return (
      <div style={{width: "160px"}}>
        <ReactDatePicker
          selected={this.props.selected}
          onChange={this.props.onChange}
          highlightDates={this.props.highlightDates}
          customInput={<Input />}
        />
      </div>
    );
  }
}

export default DatePicker;
