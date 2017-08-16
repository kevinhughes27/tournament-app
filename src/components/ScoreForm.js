import React, { Component } from 'react';
import { connect } from 'react-redux';

class ScoreForm extends Component {
  render() {
    return <div />;
  }
}

export default connect(state => ({
  games: state.app.games,
  search: state.app.search
}))(ScoreForm);
