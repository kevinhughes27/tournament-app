import React, { Component } from 'react';
import { connect } from 'react-redux';

class Submit extends Component {
  render() {
    return <div>Submit</div>;
  }
}

export default connect(state => ({
  games: state.app.games,
  search: state.app.search
}))(Submit);
