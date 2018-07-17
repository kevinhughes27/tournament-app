import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions, FormikErrors } from "formik";
import * as EmailValidator from "email-validator";

import TextField from "@material-ui/core/TextField";
import DivisionPicker from "./DivisionPicker";
import SubmitButton from "../../components/SubmitButton";

import { Form, FormAPI } from "../../components/Form";
import { onComplete, onError } from "../../helpers/formHelpers";

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
      (result) => onComplete(result, this.props, actions),
      (error) => onError(error, this.props)
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
          autoComplete="off"
          fullWidth
          value={values.name}
          onChange={handleChange}
          helperText={formProps.errors.name && formProps.errors.name}
        />
        <TextField
          name="email"
          label="Email"
          margin="normal"
          autoComplete="off"
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
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
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
