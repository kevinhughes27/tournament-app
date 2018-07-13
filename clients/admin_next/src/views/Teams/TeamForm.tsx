import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions } from "formik";

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

  onSubmit = (values: FormikValues, actions: FormikActions<FormikValues>) => {
    this.setState(defaultState);

    UpdateTeamMutation.commit(
      environment,
      values,
      this.props.team,
      (response, errors) => {
        const result = response.updateTeam;
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
          fullWidth
          value={values.name}
          onChange={handleChange}
        />
        <TextField
          name="email"
          label="Email"
          margin="normal"
          fullWidth
          value={values.email}
          onChange={handleChange}
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
        />
        <SubmitButton
          dirty={dirty}
          submitting={isSubmitting}
          text="Save"
        />
      </form>
    );
  }
}

export default withStyles(styles)(TeamForm);
