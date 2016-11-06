import _keys from 'lodash/keys';
import _times from 'lodash/times';
import _map from 'lodash/map';
import _findIndex from 'lodash/findIndex';
import _groupBy from 'lodash/groupBy';

import React from 'react';
import ReactDOM from 'react-dom';
import {Tabs, Tab} from 'react-bootstrap';
import TimeColumn from './time_column';
import GamesStore from '../stores/games_store';

class ScheduleEditor extends React.Component {
  constructor(props) {
    super(props);

    let games = JSON.parse(this.props.games);
    GamesStore.init(games);

    this.fields = JSON.parse(this.props.fields);

    this.gameWidth = 70;

    this.renderDivisionTab = this.renderDivisionTab.bind(this);
    this.renderGamesRow = this.renderGamesRow.bind(this);
    this.renderUnscheduledGame = this.renderUnscheduledGame.bind(this);
    this.renderFieldColumn = this.renderFieldColumn.bind(this);
    this.renderGameText = this.renderGameText.bind(this);
    this.onChange = this.onChange.bind(this);

    let gamesByGroup = _groupBy(GamesStore.all(), 'scheduled');

    this.state = {
      unscheduledGames: gamesByGroup[false],
      scheduledGames: gamesByGroup[true]
    };
  }

  componentDidMount() {
    GamesStore.addChangeListener(this.onChange);
  }

  componentWillUnmount() {
    GamesStore.removeChangeListener(this.onChange);
  }

  onChange() {
    let gamesByGroup = _groupBy(GamesStore.all(), 'scheduled');

    this.setState({
      unscheduledGames: gamesByGroup[false],
      scheduledGames: gamesByGroup[true]
    });
  }

  render() {
    return (
      <div>
        <div style={{paddingBottom: '10px'}}>
          {this.renderUnscheduled()}
        </div>
        {this.renderSchedule()}
      </div>
    );
  }

  renderUnscheduled() {
    let games = this.state.unscheduledGames;
    let gameByDivision = _groupBy(games, 'division')

    return (
      <div style={{paddingLeft: '5px'}}>
        <Tabs id="divisions">
          {_map(gameByDivision, this.renderDivisionTab)}
        </Tabs>
      </div>
    );
  }

  renderDivisionTab(games, divisionName) {
    let poolGames = games.filter((g) => { return g.pool });
    let bracketGames = games.filter((g) => { return g.bracket });

    let poolGamesByRound = _groupBy(poolGames, 'round')
    let poolRounds = _keys(poolGamesByRound).sort()

    let bracketGamesByRound = _groupBy(bracketGames, 'round')
    let bracketRounds = _keys(bracketGamesByRound).sort()

    return (
      <Tab key={divisionName} eventKey={divisionName} title={divisionName}>
        {_map(poolRounds, (round) => {
          return this.renderGamesRow('pool', round, poolGamesByRound[round])
        })}
        {_map(bracketRounds, (round) => {
          return this.renderGamesRow('bracket', round, bracketGamesByRound[round])
        })}
      </Tab>
    )
  }

  renderGamesRow(stage, round, games) {
    return (
      <div key={stage+round} style={{display: 'flex'}}>
        {_map(games, this.renderUnscheduledGame)}
      </div>
    )
  }

  renderUnscheduledGame(game) {
    let style = {
      width: '65px',
      height: '60px',
      margin: '5px',
      border: '1px solid',
      backgroundColor: '#a6cee3',
      textAlign: 'center'
    }

    return (
      <div key={game.id} style={style} draggable>
        {this.renderGameText(game)}
      </div>
    )
  }

  renderSchedule() {
    let fields = this.fields
    //TODO scheduledGames
    return (
      <div style={{display: 'flex'}}>
        {this.renderLabelsColumn()}
        { _map(fields, this.renderFieldColumn) }
      </div>
    );
  }

  renderLabelsColumn() {
    return (<TimeColumn
      key={'labels'}
      now={new Date(Date.now())}
      min={new Date(2016, 10, 5, 9)}
      max={new Date(2016, 10, 5, 17)}
      showLabels={true}
      rowHeight={10}
      colWidth={80}
    />)
  }

  renderFieldColumn(field, idx) {
    return (<TimeColumn
      key={field.id}
      field={field.id}
      title={field.name}
      now={new Date(Date.now())}
      min={new Date(2016, 10, 5, 9)}
      max={new Date(2016, 10, 5, 17)}
      rowHeight={10}
      colWidth={70}
    />)
  }

  renderGameText(game) {
    if (game.bracket) {
      return (
        <div>
          <h4>{game.bracket_uid}</h4>
          {game.home_prereq} v {game.away_prereq}
        </div>
      )
    } else {
      return (
        <div>
          <h4>{game.pool}</h4>
          {game.home_pool_seed} v {game.away_pool_seed}
        </div>
      )
    }
  }
}

module.exports = ScheduleEditor;
