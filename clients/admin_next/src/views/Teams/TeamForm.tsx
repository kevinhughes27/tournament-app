import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions, FormikErrors } from "formik";
import * as EmailValidator from "email-validator";

import TextField from "@material-ui/core/TextField";
import DivisionPicker from "./DivisionPicker";
import Form from "../../components/Form";
import SubmitButton from "../../components/SubmitButton";

import environment from "../../relay";
import UpdateTeamMutation from "../../mutations/UpdateTeam";

interface Props {
  team: Team;
  divisions: Division[];
}

interface State {
  message?: string;
  error?: string;
}

const defaultState = {
  message: undefined,
  error: undefined
};

class TeamForm extends React.Component<Props, State> {
  state = defaultState;

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
    this.setState(defaultState);

    UpdateTeamMutation.commit(
      environment,
      values,
      this.props.team,
      (response) => this.onComplete(response, actions),
      (error) => this.onError(error)
    );
  }

  onComplete = (response: UpdateTeamMutation, actions: FormikActions<FormikValues>) => {
    const result = response.updateTeam;

    actions.setSubmitting(false);

    if (result.success) {
      this.handleSuccess(actions);
    } else {
      this.handleFailure(result, actions);
    }
  }

  onError = (error: Error | undefined) => {
    if (error) {
      this.setState({error: error.message});
    } else {
      this.setState({error: "Something went wrong."});
    }
  }

  handleSuccess = (actions: FormikActions<FormikValues>) => {
    actions.resetForm();
    this.setState({message: "Team Saved"});
  }

  handleFailure = (result: UpdateTeam, actions: FormikActions<FormikValues>) => {
    if (result.userErrors && result.userErrors.length > 0) {
      result.userErrors.forEach((error) => actions.setFieldError(error.field, error.message));
    } else if (result.message) {
      this.setState({error: result.message});
    } else {
      this.setState({error: "Something went wrong."});
    }
  }

  render() {
    const { team } = this.props;

    const initialValues = {
      name: team.name,
      email: team.email || "",
      divisionId: team.division && team.division.id || "",
      seed: team.seed || ""
    };

    return (
      <Form error={this.state.error} message={this.state.message}>
        <Formik
          initialValues={initialValues}
          validate={this.validate}
          onSubmit={this.onSubmit}
          render={this.renderForm}
        />
      </Form>
    );
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

export default TeamForm;
