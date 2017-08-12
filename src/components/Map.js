import React, { Component } from 'react';
import { connect } from 'react-redux';

class Map extends Component {
  render() {
    return <div>Map</div>;
  }
}

export default connect(state => ({
  games: state.app.games,
  search: state.app.search
}))(Map);
