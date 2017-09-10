import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from 'material-ui/styles';
import Dialog from 'material-ui/Dialog';
import Button from 'material-ui/Button';
import Slide from 'material-ui/transitions/Slide';
import AppBar from 'material-ui/AppBar';
import Toolbar from 'material-ui/Toolbar';
import IconButton from 'material-ui/IconButton';
import Typography from 'material-ui/Typography';
import CloseIcon from 'material-ui-icons/Close';
import ScoreForm from './ScoreForm';

const styles = {
  appBar: {
    position: 'relative'
  },
  flex: {
    flex: 1
  }
};

class SubmitModal extends React.Component {
  state = {
    open: false
  };

  handleOpen = () => {
    this.setState({ open: true });
  };

  handleClose = () => {
    this.setState({ open: false });
  };

  render() {
    const { classes, game } = this.props;

    return (
      <div>
        <Button onClick={this.handleOpen}>
          {game.home_name} vs {game.away_name}
        </Button>
        <Dialog
          fullScreen
          open={this.state.open}
          onRequestClose={this.handleClose}
          transition={<Slide direction="up" />}
        >
          <AppBar className={classes.appBar}>
            <Toolbar>
              <IconButton
                color="contrast"
                onClick={this.handleClose}
                aria-label="Close"
              >
                <CloseIcon />
              </IconButton>
              <Typography type="title" color="inherit" className={classes.flex}>
                {game.home_name} vs {game.away_name}
              </Typography>
            </Toolbar>
          </AppBar>
          <div
            style={{
              paddingTop: '56px',
              marginTop: '24px',
              overflowY: 'scroll',
              overflowX: 'hidden'
            }}
          >
            <ScoreForm game={game} handleClose={this.handleClose} />
          </div>
        </Dialog>
      </div>
    );
  }
}

SubmitModal.propTypes = {
  classes: PropTypes.object.isRequired
};

export default withStyles({ styles })(SubmitModal);
