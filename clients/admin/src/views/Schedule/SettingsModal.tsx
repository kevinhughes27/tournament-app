import * as React from 'react';
import {
  Formik,
  FormikValues,
  FormikProps,
  FormikErrors,
  FormikActions
} from 'formik';
import { isEmpty } from 'lodash';

import TextField from '@material-ui/core/TextField';
import Modal from '../../components/Modal';
import FormButtons from '../../components/FormButtons';
import Settings from './Settings';

interface Props {
  open: boolean;
  handleClose: () => void;
  onUpdate: () => void;
}

class SettingsModal extends React.Component<Props> {
  initialValues = () => {
    return {
      scheduleStart: Settings.scheduleStart,
      scheduleEnd: Settings.scheduleEnd,
      scheduleInc: Settings.scheduleInc,
      defaultGameLength: Settings.defaultGameLength
    };
  };

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (!values.scheduleStart) {
      errors.scheduleStart = 'Required';
    } else if (values.scheduleStart <= 0) {
      errors.scheduleStart = 'Invalid Entry';
    }

    if (!values.scheduleEnd) {
      errors.scheduleEnd = 'Required';
    } else if (values.scheduleEnd <= 0) {
      errors.scheduleEnd = 'Invalid Entry';
    }

    if (!values.scheduleInc) {
      errors.scheduleInc = 'Required';
    } else if (values.scheduleInc <= 0) {
      errors.scheduleInc = 'Invalid Entry';
    }

    if (!values.defaultGameLength) {
      errors.defaultGameLength = 'Required';
    } else if (values.defaultGameLength <= 0) {
      errors.defaultGameLength = 'Invalid Entry';
    }

    return errors;
  };

  onSubmit = (values: FormikValues, actions: FormikActions<FormikValues>) => {
    Settings.update(values);
    Settings.save();

    this.props.onUpdate();
    this.forceUpdate();

    actions.resetForm();
    actions.setSubmitting(false);
  };

  render() {
    return (
      <Modal
        title="Settings"
        open={this.props.open}
        onClose={this.props.handleClose}
      >
        <Formik
          initialValues={this.initialValues()}
          validate={this.validate}
          onSubmit={this.onSubmit}
          render={this.renderForm}
        />
      </Modal>
    );
  }

  renderForm = (formProps: FormikProps<FormikValues>) => {
    const {
      dirty,
      values,
      errors,
      handleChange,
      handleSubmit,
      isSubmitting
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
          helperText={errors.scheduleStart}
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
          helperText={errors.scheduleEnd}
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
          helperText={errors.scheduleInc}
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
          helperText={errors.defaultGameLength}
        />
        <FormButtons
          inline
          formDirty={dirty}
          formValid={isEmpty(errors)}
          submitting={isSubmitting}
          cancel={this.props.handleClose}
        />
      </form>
    );
  };
}

export default SettingsModal;
