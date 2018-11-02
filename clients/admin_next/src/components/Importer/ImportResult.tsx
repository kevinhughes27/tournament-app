import * as React from "react";
import { Button } from "@material-ui/core";
import ImportErrors from "./ImportErrors";

interface Props {
  completed: number;
  errors: {
    [key: number]: string;
  };
  object: string;
  onClose: () => void;
}

class ImportResult extends React.Component<Props> {
  render() {
    const { completed, errors, object } = this.props;

    return (
      <div>
        <p>Imported {completed} {object}</p>
        <ImportErrors errors={errors} />
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

export default ImportResult;
