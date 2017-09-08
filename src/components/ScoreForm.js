import React, { Component } from 'react';
import { connect } from 'react-redux';
import TextField from 'material-ui/TextField';
import Button from 'material-ui/Button';
import SpiritQuestion from './SpiritQuestion';
import { submitScore } from '../actions/submitScore';
import Fingerprint2 from 'fingerprintjs2sync';
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
    event.preventDefault();

    const { game, dispatch, handleClose } = this.props;
    const teamName = this.props.search;
    const team = _find(this.props.teams, t => t.name === teamName);

    const isHome = game.home_name === teamName;
    const { home_score, away_score } = this.state;
    const homeScore = parseInt(home_score, 10);
    const awayScore = parseInt(away_score, 10);

    const payload = {
      game_id: game.id,
      team_id: team.id,
      submitter_fingerprint: new Fingerprint2().getSync().fprint,
      team_score: isHome ? homeScore : awayScore,
      opponent_score: isHome ? awayScore : homeScore,
      ..._omit(this.state, ['home_score', 'away_score'])
    };

    dispatch(submitScore(payload));
    handleClose();
  }

  render() {
    const { game, handleClose } = this.props;

    const actions = [
      <Button
        key="cancel"
        label="Cancel"
        primary={true}
        onClick={handleClose}
      />,
      <Button key="submit" type="submit" label="Submit" primary={true} />
    ];

    return (
      <form onSubmit={this.handleSubmit}>
        <div style={{ display: 'flex', justifyContent: 'space-around' }}>
          <TextField
            name="home_score"
            type="number"
            autoComplete="off"
            value={this.state.home_score}
            onChange={this.handleChange}
            floatingLabelText={game.home_name}
            style={{ flexBasis: '35%' }}
          />
          <TextField
            name="away_score"
            type="number"
            autoComplete="off"
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
        <div
          style={{
            textAlign: 'right',
            padding: 8,
            margin: '24px -24px -24px -24px'
          }}
        >
          {actions}
        </div>
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
  teams: state.app.teams,
  search: state.app.search
}))(ScoreForm);
