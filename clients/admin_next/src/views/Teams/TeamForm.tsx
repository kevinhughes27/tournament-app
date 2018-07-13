import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions } from "formik";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Form as styles } from "../../assets/jss/styles";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";

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

class TeamForm extends React.Component<Props, State> {
  state = {
    message: undefined,
    errors: undefined
  };

  onSubmit = (values: FormikValues, actions: FormikActions<FormikValues>) => {
    UpdateTeamMutation.commit(
      environment,
      values,
      this.props.team,
      (response, errors) => {
        const result = response.updateTeam;

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
      email: team.email,
      divisionId: team.division.id,
      seed: team.seed
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

  renderForm = ({values, handleChange, handleSubmit}: FormikProps<FormikValues>) => {
    const { divisions, classes } = this.props;

    return (
      <form onSubmit={handleSubmit}>
        <TextField
          id="name"
          label="Name"
          margin="normal"
          fullWidth
          value={values.name}
          onChange={handleChange}
        />
        <TextField
          id="email"
          label="Email"
          margin="normal"
          fullWidth
          value={values.email || ""}
          onChange={handleChange}
        />
        <DivisionPicker
          divisionId={values.divisionId}
          divisions={divisions}
          onChange={handleChange}
        />
        <TextField
          id="seed"
          label="Seed"
          margin="normal"
          fullWidth
          type="number"
          value={values.seed}
          onChange={handleChange}
        />
        <Button variant="contained" color="primary" type="submit" className={classes.button}>
          Save
        </Button>
      </form>
    );
  }
}

export default withStyles(styles)(TeamForm);
