import * as React from "react";

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
  button: {
    marginTop: 20
  }
};

interface Props extends WithStyles<typeof styles> {
  team: any;
  divisions: any;
}

interface State {
  name: string;
  email: string;
  divisionId: number;
  seed: number;
  open: boolean;
  message: string;
}

class TeamForm extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);

    const team = props.team;

    this.state = {
      name: team.name,
      email: team.email || "",
      divisionId: team.division.id || "",
      seed: team.seed || "",
      open: false,
      message: ""
    };
  }

  handleNameChange = (event: any) => {
    this.setState({ name: event.target.value });
  }

  handleEmailChange = (event: any) => {
    this.setState({ email: event.target.value });
  }

  handleDivisionChange = (event: any) => {
    this.setState({ divisionId: event.target.value });
  }

  handleSeedChange = (event: any) => {
    let value = event.target.value;
    value = value === "" ? value : Number(value);
    this.setState({ seed: value });
  }

  handleSubmit = () => {
    const { name, email, divisionId, seed } = this.state;
    const input = {
      name,
      email,
      divisionId,
      seed
    };

    UpdateTeamMutation.commit(
      environment,
      input,
      this.props.team,
      (response: any, errors: any) => {
        if (response.success) {
          this.setState({open: true, message: "Team Updated."});
        } else if (errors) {
          this.setState({open: true, message: "Invalid Input"});
        } else {
          this.setState({open: true, message: response.userErrors});
        }
      }
    );
  }

  handleClose = () => {
    this.setState({ open: false });
  }

  render() {
    const { divisions, classes } = this.props;

    return (
      <div>
        <TextField
          id="name"
          label="Name"
          margin="normal"
          fullWidth
          value={this.state.name}
          onChange={this.handleNameChange}
        />
        <TextField
          id="email"
          label="Email"
          margin="normal"
          fullWidth
          value={this.state.email}
          onChange={this.handleEmailChange}
        />
        <DivisionPicker
          division={this.state.divisionId}
          divisions={divisions}
          onChange={this.handleDivisionChange}
        />
        <TextField
          id="seed"
          label="Seed"
          margin="normal"
          fullWidth
          type="number"
          value={this.state.seed}
          onChange={this.handleSeedChange}
        />
        <Button variant="contained" color="primary" className={classes.button} onClick={this.handleSubmit}>
          Save
        </Button>
        <Snackbar
          anchorOrigin={{vertical: "bottom", horizontal: "left"}}
          open={this.state.open}
          autoHideDuration={2000}
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
