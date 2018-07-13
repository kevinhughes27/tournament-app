import * as React from "react";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Button from "@material-ui/core/Button";
import CircularProgress from "@material-ui/core/CircularProgress";

const styles = {
  button: {
    marginTop: 20
  }
};

interface Props extends WithStyles<typeof styles> {
  dirty: boolean;
  submitting: boolean;
  text: string;
}

class SubmitButton extends React.Component<Props> {
  render() {
    const { dirty, submitting, classes } = this.props;

    return (
      <Button
        variant="contained"
        color="primary"
        type="submit"
        className={classes.button}
        disabled={!dirty || submitting}
      >
        {this.buttonContent()}
      </Button>
    );
  }

  buttonContent = () => {
    const { submitting, text } = this.props;

    if (submitting) {
      return <CircularProgress size={20} />;
    } else {
      return text;
    }
  }
}

export default withStyles(styles)(SubmitButton);
