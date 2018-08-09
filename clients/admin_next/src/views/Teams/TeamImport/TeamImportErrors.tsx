import * as React from "react";
import { keys } from "lodash";

interface Props {
  errors: {
    [key: number]: string;
  };
}

class TeamImportErrors extends React.Component<Props> {
  render() {
    const rowNumbers = keys(this.props.errors).map((k) => parseInt(k, 10));

    return (
      <ul style={{listStyleType: "none"}}>
        {rowNumbers.map((num) => this.renderError(num, this.props.errors[num]))}
      </ul>
    );
  }

  renderError = (rowNumber: number, error: string) => {
    return (
      <li>
        row {rowNumber + 2}: {error}
      </li>
    );
  }
}

export default TeamImportErrors;
