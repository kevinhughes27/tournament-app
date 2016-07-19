var _ = require('underscore'),
    React = require('react'),
    ReactDOM = require('react-dom');

var Division = React.createClass({
  getInitialState() {
    return {
      bracketHandle: this.props.bracket_handle
    };
  },

  componentDidMount() {
    this.renderBracket();

    $('#division_bracket_type').on('change', (event) => {
      var bracketHandle = $(event.target).val();
      this.setState({ bracketHandle: bracketHandle });
    });
  },

  componentDidUpdate() {
    this.renderBracket();
  },

  renderBracket() {
    var bracketVis = new Admin.BracketVis('#bracketGraph');
    var handle = this.state.bracketHandle;
    var bracket = BracketDb.find(handle);
    bracketVis.render(bracket);
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
        <div className="row">
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
      <div className="col-md-6" key={pool}>
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
    var handle = this.state.bracketHandle;
    var bracket = BracketDb.find(handle);

    return (
      <div>
        <div className="row">
          {this.renderDescription(bracket)}
        </div>
        <hr/>
        <div className="row">
          <div className="col-md-4">
            {this.renderPools(bracket)}
          </div>
          <div className="col-md-8 pull-right">
            <div id="bracketGraph" style={{height: '440px'}}></div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = Division;
