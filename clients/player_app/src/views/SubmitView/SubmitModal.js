import React from 'react';
import { connect } from 'react-redux';
import { push } from 'connected-react-router';
import queryString from 'query-string';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Dialog from '@material-ui/core/Dialog';
import Button from '@material-ui/core/Button';
import Slide from '@material-ui/core/Slide';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import IconButton from '@material-ui/core/IconButton';
import Typography from '@material-ui/core/Typography';
import CloseIcon from '@material-ui/icons/Close';
import Done from '@material-ui/icons/Done';
import Cached from '@material-ui/icons/Cached';
import ReportProblem from '@material-ui/icons/ReportProblem';
import ScoreForm from './ScoreForm';

const styles = {
  appBar: {
    position: 'relative'
  },
  flex: {
    flex: 1
  }
};

const Transition = React.forwardRef(function Transition(props, ref) {
  return <Slide direction="up" ref={ref} {...props} />;
});

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

    if (params['gameId'] === game.id) {
      return {
        homeScore: parseInt(params['homeScore'], 10),
        awayScore: parseInt(params['awayScore'], 10)
      }
    }
  };

  handleOpen = () => {
    this.setState({ open: true });
  };

  handleClose = () => {
    this.props.dispatch(push('/submit'));
    this.setState({ open: false });
  };

  renderButton = (game, report) => {
    return (
      <div>
        <Button onClick={this.handleOpen}>
          {game.homeName} vs {game.awayName}
          <span style={{ paddingLeft: '8px' }}>
            {renderReportStatus(report)}
          </span>
        </Button>
        {renderGameScore(game, report)}
      </div>
    );
  };

  render() {
    const { classes, team, game, report } = this.props;
    const deepLink = this.deepLinkScores();

    return (
      <div>
        {this.renderButton(game, report)}
        <Dialog
          fullScreen
          open={this.state.open}
          onClose={this.handleClose}
          TransitionComponent={Transition}
        >
          <AppBar className={classes.appBar}>
            <Toolbar>
              <IconButton
                color="inherit"
                onClick={this.handleClose}
                aria-label="Close"
              >
                <CloseIcon />
              </IconButton>
              <Typography type="h6" color="inherit" className={classes.flex}>
                {game.homeName} vs {game.awayName}
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
              team={team}
              game={game}
              report={report}
              deepLink={deepLink}
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
      pending: <Cached style={{color: "lightblue"}} />,
      success: <Done style={{color: "green"}} />,
      error: <ReportProblem style={{color: "orange"}} />
    };

    return statusToIcon[report.status];
  }
}

/*
  renderGameScore - if the game is confirmed then the final score is shown.
  if the game is not confirmed then the user's submitted score is shown.
*/
function renderGameScore(game, report) {
  let html;

  if (game.scoreConfirmed) {
    html = (
      <span>
        {game.homeScore} - {game.awayScore}
      </span>
    );
  } else if (report) {
    html = (
      <span>
        {report.homeScore} - {report.awayScore}
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
