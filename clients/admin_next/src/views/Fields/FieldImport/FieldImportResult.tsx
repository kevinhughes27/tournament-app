import * as React from "react";
import { Button } from "@material-ui/core";
import FieldImportErrors from "./FieldImportErrors";

interface Props {
  completed: number;
  errors: {
    [key: number]: string;
  };
  onClose: () => void;
}

class FieldImportResult extends React.Component<Props> {
  render() {
    const { completed, errors } = this.props;

    return (
      <div>
        <p>Imported {completed} fields</p>
        <FieldImportErrors errors={errors} />
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

export default FieldImportResult;
