import * as React from 'react';
import { WithStyles, withStyles, Button, Dialog, DialogTitle, DialogContent, DialogContentText, TextField, DialogActions } from '@material-ui/core';
import AddUserMutation from '../../mutations/AddUser';
import runMutation from '../../helpers/runMutation';

const styles = {
  inviteButton: {
    marginLeft: 20
  }
}

interface Props extends WithStyles<typeof styles> {}

class AddUserModal extends React.Component<Props> {
  state = {
    open: false,
    email: ''
  }

  handleOpen = () => {
    this.setState({open: true})
  }

  handleClose = () => {
    this.setState({open: false})
  }

  complete = () => {
    this.setState({
      open: false,
      email: ''
    })
  }

  submit = () => {
    runMutation(
      AddUserMutation,
      { input: {email: this.state.email} },
      { complete: this.complete }
    )
  }

  render() {
    const { classes } = this.props;

    return (
      <>
        <Button variant="outlined" className={classes.inviteButton}onClick={this.handleOpen} >
          Add User
        </Button>
        <Dialog open={this.state.open} onClose={this.handleClose}>
          <DialogTitle>Add User</DialogTitle>
          <DialogContent>
            <DialogContentText>
              To add a user, please enter their email address here.
            </DialogContentText>
            <TextField
              autoFocus
              margin="dense"
              label="Email Address"
              type="email"
              fullWidth
              value={this.state.email}
              onChange={(ev) => this.setState({email: ev.target.value})}
            />
          </DialogContent>
          <DialogActions>
            <Button onClick={this.handleClose} color="primary">
              Cancel
            </Button>
            <Button onClick={this.submit} color="primary">
              Add User
            </Button>
          </DialogActions>
        </Dialog>
      </>
    );
  }
}

export default withStyles(styles)(AddUserModal);
