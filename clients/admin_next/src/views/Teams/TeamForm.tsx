import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { FormikValues, FormikProps, FormikErrors } from "formik";
import * as EmailValidator from "email-validator";
import { isEmpty } from "lodash";

import TextField from "@material-ui/core/TextField";
import DivisionPicker from "./DivisionPicker";
import FormButtons from "../../components/FormButtons";

import Form from "../../components/Form";
import runMutation from "../../helpers/mutationHelper";
import UpdateTeamMutation from "../../mutations/UpdateTeam";
import CreateTeamMutation from "../../mutations/CreateTeam";
import DeleteTeamMutation from "../../mutations/DeleteTeam";

interface Props extends RouteComponentProps<any> {
  input: UpdateTeamMutationVariables["input"] & CreateTeamMutationVariables["input"];
  divisions: TeamShow_divisions | TeamNew_divisions;
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

  mutation = () => {
    const teamId = this.props.input.id;

    if (teamId) {
      return UpdateTeamMutation;
    } else {
      return CreateTeamMutation;
    }
  }

  mutationInput = (values: FormikValues) => {
    const teamId = this.props.input.id;

    if (teamId) {
      return {input: {id: teamId, ...values}};
    } else {
      return {input: values};
    }
  }

  delete = () => {
    const teamId = this.props.input.id;

    if (teamId) {
      return async () => {
        await runMutation(
          DeleteTeamMutation,
          {input: {id: teamId}},
          {complete: this.deleteComplete}
        );
      };
    } else {
      return undefined;
    }
  }

  deleteComplete = () => {
    this.props.history.push("/teams");
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
          helperText={errors.name}
        />
        <TextField
          name="email"
          label="Email"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.email}
          onChange={handleChange}
          helperText={errors.email}
        />
        <DivisionPicker
          divisionId={values.divisionId}
          divisions={divisions}
          onChange={handleChange}
          helperText={errors.divisionId}
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
          helperText={errors.seed}
        />
        <FormButtons
          formDirty={dirty}
          formValid={isEmpty(errors)}
          submitting={isSubmitting}
          cancelLink={"/teams"}
          delete={this.delete()}
        />
      </form>
    );
  }
}

export default withRouter(TeamForm);
