import React, { Component } from 'react';
import { connect } from 'react-redux';
import { List, ListItem } from 'material-ui/List';
import AutoComplete from 'material-ui/AutoComplete';
import Subheader from 'material-ui/Subheader';
import Divider from 'material-ui/Divider';
import PlaceIcon from 'material-ui/svg-icons/maps/place';
import moment from 'moment';
import _groupBy from 'lodash/groupBy';
import _filter from 'lodash/filter';
import _uniq from 'lodash/uniq';

class ScheduleList extends Component {
  render() {
    const { games, search, dispatch } = this.props;

    let filteredGames;
    if (search !== '') {
      filteredGames = _filter(games, game => {
        return (
          String(game.home_name).toLowerCase().indexOf(search) >= 0 ||
          String(game.away_name).toLowerCase().indexOf(search) >= 0
        );
      });
    } else {
      filteredGames = games;
    }

    const gamesByStartTime = _groupBy(filteredGames, game => game.start_time);

    let searchItems = [];
    games.forEach(game => {
      searchItems.push(game.home_name);
      searchItems.push(game.away_name);
    });
    searchItems = _uniq(searchItems);

    return (
      <div>
        <AutoComplete
          hintText="Search Teams or Divisions"
          dataSource={searchItems}
          filter={AutoComplete.caseInsensitiveFilter}
          openOnFocus={true}
          onUpdateInput={search => {
            dispatch({ type: 'SET_SEARCH', value: search });
          }}
        />
        {Object.keys(gamesByStartTime).map(startTime => {
          const games = gamesByStartTime[startTime];
          return renderGameGroup(startTime, games);
        })}
      </div>
    );
  }
}

function renderGameGroup(startTime, games) {
  return (
    <List key={startTime}>
      <Subheader>
        {moment(startTime).format('dddd h:mm A')}
      </Subheader>
      {games.map(game => {
        return (
          <ListItem key={game.id}>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <div>
                {game.home_name} vs {game.away_name}
              </div>
              <div>
                {game.field_name}
                <PlaceIcon />
              </div>
            </div>
          </ListItem>
        );
      })}
      <Divider />
    </List>
  );
}

export default connect()(ScheduleList);
