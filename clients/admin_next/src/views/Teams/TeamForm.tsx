import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions, FormikErrors } from "formik";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Form as styles } from "../../assets/jss/styles";
import TextField from "@material-ui/core/TextField";

import SubmitButton from "../../components/SubmitButton";
import DivisionPicker from "./DivisionPicker";
import Toast from "../../components/Toast";
import Errors from "../../components/Errors";

import environment from "../../relay";
import UpdateTeamMutation from "../../mutations/UpdateTeam";

interface Props extends WithStyles<typeof styles> {
  team: Team;
  divisions: Division[];
}

interface State {
  message?: string;
  errors?: string[];
}

const defaultState = {
  message: undefined,
  errors: undefined
};

class TeamForm extends React.Component<Props, State> {
  state = defaultState;

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (!values.name) {
      errors.name = "Required";
    }

    const emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i;

    if (values.email && emailRegex.test(values.email)) {
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
      (response, errors) => {
        const result = response.updateTeam;

        actions.resetForm();
        actions.setSubmitting(false);

        if (result.success) {
          this.setState({message: "Team Saved"});
        } else if (errors) {
          this.setState({errors: ["Invalid Input"]});
        } else {
          this.setState({errors: result.userErrors});
        }
      }
    );
  }

  render() {
    const { team, classes } = this.props;

    const initialValues = {
      name: team.name,
      email: team.email || "",
      divisionId: team.division && team.division.id || "",
      seed: team.seed || ""
    };

    return (
      <div className={classes.container}>
        <Toast message={this.state.message} />
        <Errors errors={this.state.errors} />
        <Formik
          initialValues={initialValues}
          validate={this.validate}
          onSubmit={this.onSubmit}
          render={this.renderForm}
        />
      </div>
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

    const error = Object.keys(errors).length !== 0;

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
          disabled={!dirty || error}
          submitting={isSubmitting}
          text="Save"
        />
      </form>
    );
  }
}

export default withStyles(styles)(TeamForm);
