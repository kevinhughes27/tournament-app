import * as React from "react";
import { Button } from "@material-ui/core";
import TeamImportErrors from "./TeamImportErrors";

interface Props {
  completed: number;
  errors: {
    [key: number]: string;
  };
  onClose: () => void;
}

class TeamImportResult extends React.Component<Props> {
  render() {
    const { completed, errors } = this.props;

    return (
      <div>
        <p>Imported {completed} teams</p>
        <TeamImportErrors errors={errors} />
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
