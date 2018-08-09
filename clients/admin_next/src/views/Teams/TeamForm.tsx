import * as React from "react";
import { FormikValues, FormikProps, FormikErrors } from "formik";
import * as EmailValidator from "email-validator";
import { isEmpty } from "lodash";

import TextField from "@material-ui/core/TextField";
import DivisionPicker from "./DivisionPicker";
import SubmitButton from "../../components/SubmitButton";

import Form from "../../components/Form";
import UpdateTeamMutation from "../../mutations/UpdateTeam";
import CreateTeamMutation from "../../mutations/CreateTeam";

interface Props {
  input: UpdateTeamMutationVariables["input"] & CreateTeamMutationVariables["input"];
  divisions: DivisionPicker_divisions;
}

class TeamForm extends Form<Props> {
  initialValues = () => {
    const { input } = this.props;

    return {
      name: input.name,
      email: input.email || "",
      divisionId: input.divisionId || "",
      seed: input.seed || ""
    };
  }

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (!values.name) {
      errors.name = "Required";
    }

    if (values.email && !EmailValidator.validate(values.email)) {
      errors.email = "Invalid email address";
    }

    if (!values.divisionId) {
      errors.divisionId = "Required";
    }

    if (!values.seed) {
      errors.seed = "Required";
    } else if (values.seed <= 0) {
      errors.seed = "Invalid seed";
    }

    return errors;
  }

  submit = (values: FormikValues) => {
    const teamId = this.props.input.id;

    if (teamId) {
      return UpdateTeamMutation.commit({input: {id: teamId, ...values}});
    } else {
      return CreateTeamMutation.commit({input: values});
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
          helperText={formProps.errors.name}
        />
        <TextField
          name="email"
          label="Email"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.email}
          onChange={handleChange}
          helperText={formProps.errors.email}
        />
        <DivisionPicker
          divisionId={values.divisionId}
          divisions={divisions}
          onChange={handleChange}
          helperText={formProps.errors.divisionId}
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
          helperText={formProps.errors.seed}
        />
        <SubmitButton
          disabled={!dirty || !isEmpty(errors)}
          submitting={isSubmitting}
        />
      </form>
    );
  }
}

export default TeamForm;
