import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions } from "formik";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import Modal from "../../../components/Modal";
import SubmitButton from "../../../components/SubmitButton";
import Settings from "./Settings";

interface Props {
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
    return (
      <div>
        <Button onClick={this.handleOpen}>Settings</Button>
        <Modal
          title="Settings"
          open={this.state.open}
          onClose={this.handleClose}
        >
          <Formik
            initialValues={this.initialValues()}
            onSubmit={this.onSubmit}
            render={this.renderForm}
          />
        </Modal>
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
          inline
          disabled={!dirty}
          submitting={isSubmitting}
        />
      </form>
    );
  }
}

export default SettingsModal;
