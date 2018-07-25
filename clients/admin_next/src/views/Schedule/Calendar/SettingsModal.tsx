import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions } from "formik";

import { Modal as styles } from "../../../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Button from "@material-ui/core/Button";
import Modal from "@material-ui/core/Modal";
import Typography from "@material-ui/core/Typography";
import TextField from "@material-ui/core/TextField";
import IconButton from "@material-ui/core/IconButton";
import CloseIcon from "@material-ui/icons/Close";

import Settings from "./Settings";
import SubmitButton from "../../../components/SubmitButton";

interface Props extends WithStyles<typeof styles> {
  onUpdate: () => void;
}

class SettingsModal extends React.Component<Props> {
  state = {
    open: false,
  };

  handleOpen = () => {
    this.setState({ open: true });
  }

  handleClose = () => {
    this.setState({ open: false });
  }

  initialValues = () => {
    return {
      scheduleStart: Settings.scheduleStart,
      scheduleEnd: Settings.scheduleEnd,
      scheduleInc: Settings.scheduleInc,
      defaultGameLength: Settings.defaultGameLength
    };
  }

  onSubmit = (values: FormikValues, actions: FormikActions<FormikValues>) => {
    Settings.update(values);
    Settings.save();

    this.props.onUpdate();
    this.forceUpdate();

    actions.resetForm();
    actions.setSubmitting(false);
  }

  render() {
    const { classes } = this.props;

    return (
      <div>
        <Button onClick={this.handleOpen}>Settings</Button>
        <Modal open={this.state.open} onClose={this.handleClose}>
          <div className={classes.paper}>
            {this.renderTitle()}
            <Formik
              initialValues={this.initialValues()}
              onSubmit={this.onSubmit}
              render={this.renderForm}
            />
          </div>
        </Modal>
      </div>
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
          Settings
        </Typography>
        <IconButton onClick={this.handleClose}>
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
        <TextField
          name="scheduleStart"
          label="Schedule Start"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.scheduleStart}
          onChange={handleChange}
        />
        <TextField
          name="scheduleEnd"
          label="Schedule End"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.scheduleEnd}
          onChange={handleChange}
        />
        <TextField
          name="scheduleInc"
          label="Schedule Increment"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.scheduleInc}
          onChange={handleChange}
        />
        <TextField
          name="defaultGameLength"
          label="Default Game Length"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.defaultGameLength}
          onChange={handleChange}
        />
        <SubmitButton
          disabled={!dirty}
          submitting={isSubmitting}
          text="Save"
        />
      </form>
    );
  }
}

export default withStyles(styles)(SettingsModal);
