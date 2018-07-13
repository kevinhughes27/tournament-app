import * as React from "react";
import { Formik } from "formik";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import Snackbar from "@material-ui/core/Snackbar";
import IconButton from "@material-ui/core/IconButton";
import CloseIcon from "@material-ui/icons/Close";

import DivisionPicker from "./DivisionPicker";

import environment from "../../relay";
import UpdateTeamMutation from "../../mutations/UpdateTeam";

const styles = {
  container: {
    padding: 20
  },
  button: {
    marginTop: 20
  }
};

interface Props extends WithStyles<typeof styles> {
  team: Team;
  divisions: Division[];
}

interface State {
  open: boolean;
  message: string;
}

class TeamForm extends React.Component<Props, State> {
  state = {
    open: false,
    message: ""
  };

  handleClose = () => {
    this.setState({open: false});
  }

  render() {
    const { team, divisions, classes } = this.props;

    return (
      <div className={classes.container}>
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
                  this.setState({open: true, message: "Team Saved"});
                } else if (errors) {
                  this.setState({open: true, message: "Invalid Input"});
                } else {
                  this.setState({open: true, message: response.userErrors});
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
        <Snackbar
          anchorOrigin={{vertical: "bottom", horizontal: "left"}}
          open={this.state.open}
          autoHideDuration={1500}
          onClose={this.handleClose}
          ContentProps={{"aria-describedby": "message-id"}}
          message={<span id="message-id">{this.state.message}</span>}
          action={[
            <IconButton
              key="close"
              aria-label="Close"
              color="inherit"
              onClick={this.handleClose}
            >
              <CloseIcon />
            </IconButton>
          ]}
        />
      </div>
    );
  }
}

export default withStyles(styles)(TeamForm);
