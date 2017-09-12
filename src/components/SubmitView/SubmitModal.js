import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { withStyles } from 'material-ui/styles';
import Dialog from 'material-ui/Dialog';
import Button from 'material-ui/Button';
import { Done, Cached, ReportProblem } from 'material-ui-icons';
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

  renderButton = (game, report, teamName) => {
    return (
      <div>
        <Button onClick={this.handleOpen}>
          {game.home_name} vs {game.away_name}
          <span style={{ paddingLeft: '8px' }}>{renderReport(report)}</span>
        </Button>
        {gameScore(game, report, teamName)}
      </div>
    );
  };

  render() {
    const { classes, game, report } = this.props;
    const teamName = this.props.search;

    return (
      <div>
        {this.renderButton(game, report, teamName)}
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

function renderReport(report) {
  if (report) {
    const statusToIcon = {
      null: null,
      pending: <Cached color="lightblue" />,
      success: <Done color="green" />,
      error: <ReportProblem color="orange" />
    };

    return statusToIcon[report.status];
  }
}

/*
  gameScore - if the game is confirmed then the final score is shown.
  if the game is not confirmed then the user's submitted score is shown.
*/
function gameScore(game, report, teamName) {
  let html;

  if (game.score_confirmed) {
    html = (
      <span>
        {game.home_score} - {game.away_score}
      </span>
    );
  } else if (report) {
    //TODO I am pretty sure report should have home and away score instead of us and opponent score
    const isHome = game.home_name === teamName;
    const homeScore = isHome ? report.team_score : report.opponent_score;
    const awayScore = isHome ? report.opponent_score : report.team_score;
    html = (
      <span>
        {homeScore} - {awayScore}
      </span>
    );
  }

  if (html) {
    return (
      <div style={{ paddingLeft: '16px' }}>
        {html}
      </div>
    );
  }
}

SubmitModal.propTypes = {
  classes: PropTypes.object.isRequired
};

const styledSubmitModel = withStyles({ styles })(SubmitModal);

export default connect(state => ({
  teams: state.tournament.teams,
  search: state.search
}))(styledSubmitModel);
