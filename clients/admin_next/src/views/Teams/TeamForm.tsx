import * as React from "react";
import { FormikValues, FormikProps, FormikErrors } from "formik";
import * as EmailValidator from "email-validator";
import { isEmpty } from "lodash";

import TextField from "@material-ui/core/TextField";
import DivisionPicker from "./DivisionPicker";
import SubmitButton from "../../components/SubmitButton";

import Form from "../../components/Form";
import UpdateTeamMutation from "../../mutations/UpdateTeam";

interface Props {
  team: Team;
  divisions: Division[];
}

class TeamForm extends Form<Props> {
  initialValues = () => {
    const { team } = this.props;

    return {
      name: team.name,
      email: team.email || "",
      divisionId: team.division && team.division.id || "",
      seed: team.seed || ""
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

    if (values.seed && values.seed <= 0) {
      errors.seed = "Invalid seed";
    }

    return errors;
  }

  submit = (values: FormikValues) => {
    return UpdateTeamMutation.commit(values, this.props.team);
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
          disabled={!dirty || !isEmpty(errors)}
          submitting={isSubmitting}
          text="Save"
        />
      </form>
    );
  }
}

export default TeamForm;
