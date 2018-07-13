import * as React from "react";
import { Formik } from "formik";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Form as styles } from "../../assets/jss/styles";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";

import DivisionPicker from "./DivisionPicker";
import Toast from "../../components/Toast";

import environment from "../../relay";
import UpdateTeamMutation from "../../mutations/UpdateTeam";

interface Props extends WithStyles<typeof styles> {
  team: Team;
  divisions: Division[];
}

interface State {
  message?: string;
}

class TeamForm extends React.Component<Props, State> {
  state = {
    message: undefined
  };

  render() {
    const { team, divisions, classes } = this.props;

    return (
      <div className={classes.container}>
        <Toast message={this.state.message} />
        <Formik
          initialValues={{
            name: team.name,
            email: team.email,
            divisionId: team.division.id,
            seed: team.seed
          }}
          onSubmit={(
            values,
          ) => {
            UpdateTeamMutation.commit(
              environment,
              values,
              this.props.team,
              (response: any, errors: any) => {
                if (response.success) {
                  this.setState({message: "Team Saved"});
                } else if (errors) {
                  this.setState({message: "Invalid Input"});
                } else {
                  this.setState({message: response.userErrors});
                }
              }
            );
          }}
          render={({
            values,
            handleChange,
            handleSubmit,
          }) => (
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
          )}
        />
      </div>
    );
  }
}

export default withStyles(styles)(TeamForm);
