var _ = require('underscore'),
    React = require('react'),
    ReactDOM = require('react-dom');

var Division = React.createClass({
  getInitialState() {
    var bracketHandle = this.props.bracket_handle;
    var bracket = BracketDb.find(bracketHandle);

    return {
      bracketHandle: bracketHandle,
      bracket: bracket
    };
  },

  componentDidMount() {
    this.renderBracket();

    $('#division_bracket_type').on('change', (event) => {
      var bracketHandle = $(event.target).val();
      var bracket = BracketDb.find(bracketHandle);

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
    var bracketVis = new Admin.BracketVis('#bracketGraph');
    var bracket = this.state.bracket;

    if (bracket) {
      bracketVis.render(bracket);
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
    var games = bracket.template.games;
    games = _.filter(games, 'pool');

    if(games.length > 0) {
      var pools;
      var teamsByPool = {};
      var gamesByPool = _.groupBy(games, 'pool');

      _.each(gamesByPool, function(games, pool) {
        var homeTeams = _.pluck(games, 'home');
        var awayTeams = _.pluck(games, 'away');
        var teams = _.union(homeTeams, awayTeams);
        teamsByPool[pool] = _.sortBy(teams, function(t){ return t});
        pools = _.keys(teamsByPool);
      });

      return (
        <div style={{display: 'flex', flexWrap: 'wrap', justifyContent: 'space-around'}}>
          { pools.map((pool) => {
            return this.renderPool(pool, teamsByPool[pool]);
          })}
        </div>
      );
    } else {
      return (
        <div className="blank-slate" style="margin-top: 60px;">
          <p>No Pool Games</p>
        </div>
      );
    }
  },

  renderPool(pool, teams) {
    return (
      <div style={{minWidth: '140px'}} key={pool}>
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
  },

  render() {
    var bracket = this.state.bracket;

    if (bracket) {
      return (
        <div>
          {this.renderDescription(bracket)}
          <hr/>
          {this.renderPools(bracket)}
          <div id="bracketGraph" style={{height: '440px'}}></div>
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
