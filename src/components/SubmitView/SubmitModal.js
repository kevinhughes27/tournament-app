import React from 'react';
import { connect } from 'react-redux';
import { push } from 'react-router-redux';
import queryString from 'query-string';
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

  componentDidMount() {
    this.gameDeepLink();
  }

  gameDeepLink = () => {
    const { game, params } = this.props;

    if (params['gameId'] === game.id) {
      this.setState({ open: true });
    }
  };

  deepLinkScores = () => {
    const { game, params } = this.props;

    let scores = {
      homeScore: '',
      awayScore: ''
    };

    if (params['gameId'] === game.id) {
      scores.homeScore = parseInt(params['homeScore'], 10);
      scores.awayScore = parseInt(params['awayScore'], 10);
    }

    return scores;
  };

  handleOpen = () => {
    this.setState({ open: true });
  };

  handleClose = () => {
    this.props.dispatch(push('/submit'));
    this.setState({ open: false });
  };

  renderButton = (game, report, teamName) => {
    return (
      <div>
        <Button onClick={this.handleOpen}>
          {game.home_name} vs {game.away_name}
          <span style={{ paddingLeft: '8px' }}>
            {renderReportStatus(report)}
          </span>
        </Button>
        {gameScore(game, report, teamName)}
      </div>
    );
  };

  render() {
    const { classes, game, report } = this.props;
    const teamName = this.props.search;
    const { homeScore, awayScore } = this.deepLinkScores();

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
            <ScoreForm
              game={game}
              homeScore={homeScore}
              awayScore={awayScore}
              handleClose={this.handleClose}
            />
          </div>
        </Dialog>
      </div>
    );
  }
}

function renderReportStatus(report) {
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
    html = (
      <span>
        {report.home_score} - {report.away_score}
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
  search: state.search,
  params: queryString.parse(state.router.location.search)
}))(styledSubmitModel);
