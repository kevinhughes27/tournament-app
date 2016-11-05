import _keys from 'lodash/keys';
import _map from 'lodash/map';
import _findIndex from 'lodash/findIndex';
import _groupBy from 'lodash/groupBy';

import React from 'react';
import ReactDOM from 'react-dom';
import ReactGridLayout from 'react-grid-layout';
import {Tabs, Tab} from 'react-bootstrap';

class ScheduleEditor extends React.Component {
  constructor(props) {
    super(props);

    this.fields = JSON.parse(this.props.fields);
    let games = JSON.parse(this.props.games);
    let group = _groupBy(games, 'scheduled');
    this.scheduledGames = group[true];
    this.unscheduledGames = group[false];

    this.renderScheduledGame = this.renderScheduledGame.bind(this);
    this.renderDivisionTab = this.renderDivisionTab.bind(this);
    this.renderGamesRow = this.renderGamesRow.bind(this);
    this.renderUnscheduledGame = this.renderUnscheduledGame.bind(this);
    this.renderGameText = this.renderGameText.bind(this);
  }

  render() {
    return (
      <div>
        {this.renderUnscheduled()}
        {this.renderSchedule()}
      </div>
    );
  }

  renderUnscheduled() {
    let games = this.unscheduledGames;
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
      width: '59px',
      height: '70px',
      margin: '5px'
    }

    return (
      <div key={game.id} className="react-grid-item" style={style} draggable>
        {this.renderGameText(game)}
      </div>
    )
  }

  renderSchedule() {
    let fields = this.fields;
    let games = this.scheduledGames;

    let gridProps = {
      cols: fields.length,
      rowHeight: 30,
      width: 70 * fields.length,
      verticalCompact: false,
      autoSize: false
    };

    return (
      <div>
        {this.renderHeader(fields)}
        <ReactGridLayout {...gridProps}>
          {_map(games, this.renderScheduledGame)}
        </ReactGridLayout>
      </div>
    );
  }

  renderHeader() {
    let fields = this.fields;
    let gameWidth = this.gameWidth();

    return (
      <div style={{display: 'flex', marginLeft: '10px'}}>
        { _map(fields, (f) => this.renderFieldCell(f, gameWidth)) }
      </div>
    );
  }

  renderFieldCell(field, width) {
    return (
      <div key={field.name} style={{minWidth: width, maxWidth: width}}>
        {field.name}
      </div>
    );
  }

  renderScheduledGame(game) {
    let x = _findIndex(this.fields, (f) => { return f.id == game.field_id });

    let dataGrid = {
      x: x,
      y: 0, // based on start time
      w: 1, // constant
      h: 2, // based on game length
      minW: 1, // constant
      maxW: 1 // constant
    };

    return (
      <div key={game.id} data-grid={dataGrid}>
        {this.renderGameText(game)}
      </div>
    );
  }

  renderGameText(game) {
    if (game.bracket) {
      return (
        <div>
          <p>{game.bracket_uid}</p>
          <p>{game.home_prereq} v {game.away_prereq}</p>
        </div>
      )
    } else {
      return (
        <div>
          <p>{game.pool}</p>
          <p>{game.home_pool_seed} v {game.away_pool_seed}</p>
        </div>
      )
    }
  }

  gameWidth() {
    return 70;
  }
}

module.exports = ScheduleEditor;
