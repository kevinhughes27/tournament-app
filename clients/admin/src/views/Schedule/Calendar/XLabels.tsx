import * as React from "react";

interface Props {
  fields: ScheduleEditorQuery["fields"];
}

class XLabels extends React.Component<Props> {
  render() {
    const fields = this.props.fields;

    const labels = fields.map((field) => {
      return (
        <div key={field.name} className="x-label">
          {field.name}
        </div>
      );
    });

    return (
      <div className="x-labels">
        {labels}
      </div>
    );
  }
}

export default XLabels;
