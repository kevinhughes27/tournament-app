import React, { Component } from 'react';
import { connect } from 'react-redux';
import TextField from 'material-ui/TextField';
import RaisedButton from 'material-ui/RaisedButton';
import SpiritQuestion from './SpiritQuestion';
import { submitScore } from '../actions/submitScore';
import _find from 'lodash/find';

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
    const { dispatch } = this.props;
    dispatch(submitScore(this.state));
    event.preventDefault();
  }

  // Bottom bar needs to be hidden for this view.
  // a) its confusing since you haven't seen the submit button yet.
  //    I clicked submit scores by accident when my intention was to submit the form.
  // b) the user should finish this action or cancel

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
  search: state.app.search
}))(ScoreForm);
