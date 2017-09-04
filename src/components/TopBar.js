import React, { Component } from 'react';
import { connect } from 'react-redux';
import AppBar from 'material-ui/AppBar';
import AutoComplete from 'material-ui/AutoComplete';
import IconButton from 'material-ui/IconButton';
import SearchIcon from 'material-ui-icons/Search';

class TopBar extends Component {
  render() {
    const { teams = [], search, dispatch } = this.props;
    const teamNames = teams.map(t => t.name);

    const searchInput = (
      <AutoComplete
        hintText="Search Teams"
        dataSource={teamNames}
        filter={AutoComplete.caseInsensitiveFilter}
        searchText={search}
        openOnFocus={true}
        onUpdateInput={search => {
          dispatch({ type: 'SET_SEARCH', value: search });
        }}
      />
    );

    return (
      <AppBar
        title={searchInput}
        iconElementLeft={
          <IconButton>
            <SearchIcon />
          </IconButton>
        }
      />
    );
  }
}

export default connect(state => ({
  teams: state.app.teams,
  search: state.app.search
}))(TopBar);
