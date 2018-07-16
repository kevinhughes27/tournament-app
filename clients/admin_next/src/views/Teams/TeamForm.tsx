import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions, FormikErrors } from "formik";
import * as EmailValidator from "email-validator";

import TextField from "@material-ui/core/TextField";
import DivisionPicker from "./DivisionPicker";
import { Form, FormAPI } from "../../components/Form";
import SubmitButton from "../../components/SubmitButton";

import environment from "../../relay";
import UpdateTeamMutation from "../../mutations/UpdateTeam";

interface Props {
  team: Team;
  divisions: Division[];
}

class TeamForm extends React.Component<Props & FormAPI> {
  initialValues = () => {
    const { team } = this.props;

    return {
      name: team.name,
      email: team.email || "",
      divisionId: team.division && team.division.id || "",
      seed: team.seed || ""
    };
  }

  render() {
    return (
      <Formik
        initialValues={this.initialValues()}
        validate={this.validate}
        onSubmit={this.onSubmit}
        render={this.renderForm}
      />
    );
  }

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (!values.name) {
      errors.name = "Required";
    }

    if (values.email && !EmailValidator.validate(values.email)) {
      errors.email = "Invalid email address";
    }

    if (values.seed && values.seed <= 0) {
      errors.seed = "Invalid seed";
    }

    return errors;
  }

  onSubmit = (values: FormikValues, actions: FormikActions<FormikValues>) => {
    this.props.reset();

    UpdateTeamMutation.commit(
      environment,
      values,
      this.props.team,
      (response) => this.onComplete(response, actions),
      (error) => this.props.showError(error)
    );
  }

  onComplete = (result: UpdateTeam, actions: FormikActions<FormikValues>) => {
    actions.setSubmitting(false);

    if (result.success) {
      this.handleSuccess(actions);
    } else {
      this.handleFailure(result, actions);
    }
  }

  handleSuccess = (actions: FormikActions<FormikValues>) => {
    actions.resetForm();
    this.props.showMessage("Team Saved");
  }

  handleFailure = (result: UpdateTeam, actions: FormikActions<FormikValues>) => {
    if (result.userErrors && result.userErrors.length > 0) {
      result.userErrors.forEach((error) => actions.setFieldError(error.field, error.message));
    } else if (result.message) {
      this.props.showError(result.message);
    } else {
      this.props.showError("Something went wrong.");
    }
  }

  renderForm = (formProps: FormikProps<FormikValues>) => {
    const { divisions } = this.props;
    const {
      values,
      dirty,
      errors,
      handleChange,
      handleSubmit,
      isSubmitting
    } = formProps;

    const hasErrors = Object.keys(errors).length !== 0;

    return (
      <form onSubmit={handleSubmit}>
        <TextField
          name="name"
          label="Name"
          margin="normal"
          fullWidth
          value={values.name}
          onChange={handleChange}
          helperText={formProps.errors.name && formProps.errors.name}
        />
        <TextField
          name="email"
          label="Email"
          margin="normal"
          fullWidth
          value={values.email}
          onChange={handleChange}
          helperText={formProps.errors.email && formProps.errors.email}
        />
        <DivisionPicker
          divisionId={values.divisionId}
          divisions={divisions}
          onChange={handleChange}
        />
        <TextField
          name="seed"
          label="Seed"
          margin="normal"
          fullWidth
          type="number"
          value={values.seed}
          onChange={handleChange}
          helperText={formProps.errors.seed && formProps.errors.seed}
        />
        <SubmitButton
          disabled={!dirty || hasErrors}
          submitting={isSubmitting}
          text="Save"
        />
      </form>
    );
  }
}

export default Form(TeamForm);
