import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Login as styles } from "../../assets/jss/styles";

import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Card from "@material-ui/core/Card";
import CardActions from "@material-ui/core/CardActions";
import CardContent from "@material-ui/core/CardContent";
import Typography from "@material-ui/core/Typography";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";

import auth from "../../auth";

interface Props extends WithStyles<typeof styles> {
  onComplete: () => void;
}

interface State {
  email: string;
  password: string;
}

class LoginForm extends React.Component<Props, State> {
  state = {
    email: "",
    password: ""
  };

  handleChange = (event: React.FormEvent<EventTarget>) => {
    const target = event.target as HTMLInputElement;
    this.setState({[target.name]: target.value} as any);
  }

  handleSubmit = (ev: React.FormEvent<EventTarget>) => {
    ev.preventDefault();

    auth.login(this.state.email, this.state.password).then(() => {
      this.props.onComplete();
    });
  }

  render() {
    const { classes } = this.props;

    return (
      <div>
        <AppBar position="static">
          <Toolbar>
            <Typography variant="title" className={classes.title}>
              Ultimate Tournament
            </Typography>
          </Toolbar>
        </AppBar>
        <div className={classes.container}>
          <Card className={classes.card}>
            <form onSubmit={this.handleSubmit}>
              <CardContent>
                <Typography variant="subheading">
                  Log in to manage your tournament
                </Typography>
                <TextField
                  name="email"
                  label="Username"
                  margin="normal"
                  fullWidth
                  value={this.state.email}
                  onChange={this.handleChange}
                />

                <TextField
                  name="password"
                  label="Password"
                  margin="normal"
                  type="password"
                  fullWidth
                  value={this.state.password}
                  onChange={this.handleChange}
                />
              </CardContent>
              <CardActions className={classes.actions}>
                <Button color="primary" variant="contained" type="submit">
                  Log in
                </Button>
              </CardActions>
            </form>
          </Card>
        </div>
      </div>
    );
  }
}

export default withStyles(styles)(LoginForm);
