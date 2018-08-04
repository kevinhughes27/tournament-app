import * as React from "react";
import { Button } from "@material-ui/core";

interface Props {
  completed: number;
  errors: any;
  onClose: () => void;
}

class TeamImportResult extends React.Component<Props> {
  render() {
    const { completed, errors } = this.props;

    return (
      <div>
        <p>Imported {completed} teams</p>
        {JSON.stringify(errors)}
        <Button
          variant="contained"
          color="primary"
          style={{marginTop: 20, float: "right"}}
          onClick={this.props.onClose}
        >
          Done
        </Button>
      </div>
    );
  }
}

export default TeamImportResult;
