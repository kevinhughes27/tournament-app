var _ = require('lodash'),
    React = require('react'),
    ReactDOM = require('react-dom');

var Pool = React.createClass({
  render() {
    var pool = this.props.pool;
    var teams = this.props.teams;

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
    var games = _.filter(bracket.template.games, 'pool');
    var pools;
    var teamsByPool = {};
    var gamesByPool = _.groupBy(games, 'pool');

    _.each(gamesByPool, function(games, pool) {
      var homeTeams = _.map(games, 'home_prereq');
      var awayTeams = _.map(games, 'away_prereq');
      var teams = _.union(homeTeams, awayTeams);
      teamsByPool[pool] = _.sortBy(teams, function(t){ return t});
      pools = _.keys(teamsByPool);
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
    var bracket = this.state.bracket;
    var hasPools = bracket.pool;

    if (bracket) {
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
