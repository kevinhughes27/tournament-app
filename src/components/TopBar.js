import React, { Component } from 'react';
import { connect } from 'react-redux';
import queryString from 'query-string';

import AppBar from 'material-ui/AppBar';
import Toolbar from 'material-ui/Toolbar';
import IconButton from 'material-ui/IconButton';
import SearchIcon from 'material-ui-icons/Search';
import AutoComplete from './AutoComplete';
import Typography from 'material-ui/Typography';

class TopBar extends Component {
  componentWillMount() {
    teamDeepLink(this.props.params, this.props.dispatch);
  }

  render() {
    const { teams, search, dispatch } = this.props;
    const teamNames = teams.map(t => t.name);

    return (
      <AppBar>
        <Toolbar>
          <IconButton color="contrast">
            <SearchIcon />
          </IconButton>
          <Typography type="title" color="inherit">
            <AutoComplete
              value={search}
              placeholder="Search Teams"
              suggestions={teamNames}
              onChange={search => {
                dispatch({ type: 'SET_SEARCH', value: search });
              }}
            />
          </Typography>
        </Toolbar>
      </AppBar>
    );
  }
}

function teamDeepLink(params, dispatch) {
  const teamName = queryString.parse(params)['teamName'];

  if (teamName) {
    dispatch({ type: 'SET_SEARCH', value: teamName });
  }
}

export default connect(state => ({
  params: state.router.location.search,
  search: state.search,
  teams: state.tournament.teams
}))(TopBar);
