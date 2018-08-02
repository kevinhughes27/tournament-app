import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions } from "formik";

import { Modal as styles } from "../../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Button from "@material-ui/core/Button";
import Modal from "@material-ui/core/Modal";
import Typography from "@material-ui/core/Typography";
import TextField from "@material-ui/core/TextField";
import IconButton from "@material-ui/core/IconButton";
import CloseIcon from "@material-ui/icons/Close";
import ImportIcon from "@material-ui/icons/GroupAdd";

interface Props extends WithStyles<typeof styles> {
  open: boolean;
  handleClose: () => void;
}

class TeamImportModal extends React.Component<Props> {
  initialValues = () => {
    return {};
  }

  onSubmit = (values: FormikValues, actions: FormikActions<FormikValues>) => {
    return null;
  }

  render() {
    const { classes } = this.props;

    return (
      <Modal open={this.props.open} onClose={this.props.handleClose}>
        <div className={classes.paper}>
          {this.renderTitle()}
          <Formik
            initialValues={this.initialValues()}
            onSubmit={this.onSubmit}
            render={this.renderForm}
          />
        </div>
      </Modal>
    );
  }

  renderTitle = () => {
    const style = {
      display: "flex",
      justifyContent: "space-between",
      alignItems: "center"
    };

    return (
      <div style={style}>
        <Typography variant="title">
          Import Teams
        </Typography>
        <IconButton onClick={this.props.handleClose}>
          <CloseIcon />
        </IconButton>
      </div>
    );
  }

  renderForm = (formProps: FormikProps<FormikValues>) => {
    const {
      dirty,
      values,
      handleChange,
      handleSubmit,
      isSubmitting,
    } = formProps;

    return (
      <form onSubmit={handleSubmit}>
        <Button
          variant="contained"
          color="primary"
          type="submit"
          className={this.props.classes.button}
          disabled={!dirty || isSubmitting}
        >
          <ImportIcon />
        </Button>
      </form>
    );
  }
}

export default withStyles(styles)(TeamImportModal);
