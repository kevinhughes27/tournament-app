import React, { Component } from 'react';
import { connect } from 'react-redux';
import TextField from 'material-ui/TextField';
import RaisedButton from 'material-ui/RaisedButton';
import SpiritQuestion from './SpiritQuestion';
import { submitScore } from '../actions/submitScore';
import _find from 'lodash/find';
import _omit from 'lodash/omit';

const QUESTIONS = [
  '1. Rules knowledge and Use',
  '2. Fouls and Body Contact',
  '3. Fair-Mindedness',
  '4. Positive Attitude and Self-Control',
  '5. Communication'
];

const EXAMPLES = [
  "Examples: They didn't purposefully misinterpret the rules. They kept to time limits. When they didn't know the rules they showed a real willingness to learn",
  'Examples: They avoided fouling, contact, and dangerous plays.',
  'Examples: They apologized in situations where it was appropriate, informed teammates about wrong/unnecessary calls. Only called significant breaches',
  'Examples: They were polite. They played with appropriate intensity irrespective of the score. They left an overall positive impression during and after the game.',
  'Examples: They communicated respectfully. They listened. They kept to discussion time limits.'
];

const HANDLES = [
  'rules_knowledge',
  'fouls',
  'fairness',
  'attitude',
  'communication'
];

class ScoreForm extends Component {
  constructor(props) {
    super(props);

    let initialState = {};
    HANDLES.forEach(h => {
      initialState[h] = 3;
    });

    this.state = {
      home_score: '',
      away_score: '',
      ...initialState
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    const target = event.target;
    const value = target.type === 'checkbox' ? target.checked : target.value;
    const name = target.name;

    this.setState({
      [name]: value
    });
  }

  handleSubmit(event) {
    const gameId = this.props.match.params.gameId;
    const game = _find(this.props.games, g => g.id === gameId);
    const teamName = this.props.search;
    const team = _find(this.props.teams, t => t.name === teamName);

    const isHome = game.home_name === teamName;
    const { home_score, away_score } = this.state;
    const homeScore = parseInt(home_score, 10);
    const awayScore = parseInt(away_score, 10);

    const payload = {
      game_id: game.id,
      team_id: team.id,
      submitter_fingerprint: 'wat',
      team_score: isHome ? homeScore : awayScore,
      opponent_score: isHome ? awayScore : homeScore,
      ..._omit(this.state, ['home_score', 'away_score'])
    };

    const { dispatch } = this.props;
    dispatch(submitScore(payload));
    event.preventDefault();
  }

  render() {
    const gameId = this.props.match.params.gameId;
    const game = _find(this.props.games, g => g.id === gameId);

    return (
      <form onSubmit={this.handleSubmit}>
        <div style={{ display: 'flex', justifyContent: 'space-around' }}>
          <TextField
            name="home_score"
            value={this.state.home_score}
            onChange={this.handleChange}
            floatingLabelText={game.home_name}
            style={{ flexBasis: '35%' }}
          />
          <TextField
            name="away_score"
            value={this.state.away_score}
            onChange={this.handleChange}
            floatingLabelText={game.away_name}
            style={{ flexBasis: '35%' }}
          />
        </div>
        <div style={{ padding: 20 }}>
          {[0, 1, 2, 3, 4].map(i =>
            renderSpiritQuestion(i, this.state[HANDLES[i]])
          )}
        </div>
        <RaisedButton
          type="submit"
          label="Submit Score"
          primary={true}
          fullWidth={true}
        />
      </form>
    );
  }
}

function renderSpiritQuestion(index, value) {
  return (
    <SpiritQuestion
      key={index}
      value={value}
      question={QUESTIONS[index]}
      handle={HANDLES[index]}
      example={EXAMPLES[index]}
    />
  );
}

export default connect(state => ({
  games: state.app.games,
  teams: state.app.teams,
  search: state.app.search
}))(ScoreForm);
