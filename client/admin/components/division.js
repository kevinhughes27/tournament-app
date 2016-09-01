import _groupBy from 'lodash/groupBy';
import _sortBy from 'lodash/sortBy';
import _filter from 'lodash/filter';
import _union from 'lodash/union';
import _each from 'lodash/each';
import _keys from 'lodash/keys';
import _map from 'lodash/map';

import React from 'react';
import ReactDOM from 'react-dom';
import BracketVis from '../modules/bracket_vis';

let Pool = React.createClass({
  render() {
    let pool = this.props.pool;
    let teams = this.props.teams;

    return (
      <div style={{minWidth: '140px'}}>
        <table className="table table-bordered table-striped table-hover table-condensed">
          <thead>
            <tr>
              <th>Pool {pool}</th>
            </tr>
          </thead>

          <tbody>
            { teams.map(function(team) {
              return (
                <tr key={team}>
                  <td>{team}</td>
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    );
  }
});

let Division = React.createClass({
  getInitialState() {
    let bracketHandle = this.props.bracket_handle;
    let bracket = BracketDb.find(bracketHandle);

    return {
      bracketHandle: bracketHandle,
      bracket: bracket
    };
  },

  componentDidMount() {
    this.renderBracket();

    $('#division_bracket_type').on('change', (event) => {
      let bracketHandle = $(event.target).val();
      let bracket = BracketDb.find(bracketHandle);

      this.setState({
        bracketHandle: bracketHandle,
        bracket: bracket
      });
    });
  },

  componentDidUpdate() {
    this.renderBracket();
  },

  renderBracket() {
    let bracketVis = new BracketVis('#bracketGraph');
    let bracket = this.state.bracket;
    let bracketTree = this.props.bracket_tree;

    if (bracket) {
      bracketVis.render(bracket, bracketTree);
    }
  },

  renderDescription(bracket) {
    return (
      <div>
        <p>
          <strong>{bracket.name}</strong>
        </p>
        <p>{bracket.description}</p>
      </div>
    );
  },

  renderPools(bracket) {
    let games = this.props.games || bracket.template.games;
    let poolGames = _filter(games, 'pool');

    let pools;
    let teamsByPool = {};
    let gamesByPool = _groupBy(poolGames, 'pool');

    _each(gamesByPool, function(poolGames, pool) {
      let homeTeams = _map(poolGames, 'home_prereq');
      let awayTeams = _map(poolGames, 'away_prereq');
      let teams = _union(homeTeams, awayTeams);
      teamsByPool[pool] = _sortBy(teams, function(t){ return t});
      pools = _keys(teamsByPool);
    });

    return (
      <div style={{display: 'flex', flexWrap: 'wrap', justifyContent: 'space-around'}}>
        { pools.map((pool) => {
          return <Pool key={pool} pool={pool} teams={teamsByPool[pool]}/>
        })}
      </div>
    );
  },

  render() {
    let bracket = this.state.bracket;

    if (bracket) {
      let hasPools = bracket.pool;

      return (
        <div>
          {this.renderDescription(bracket)}
          <hr/>
          { hasPools ? this.renderPools(bracket) : null }
          <div style={{paddingLeft: '30px', paddingRight: '30px', height: '440px'}}>
            <div id="bracketGraph" style={{height: '100%'}}></div>
          </div>
        </div>
      );
    } else {
      return (
        <div>
          No brackets found.
        </div>
      )
    }
  }
});

module.exports = Division;
