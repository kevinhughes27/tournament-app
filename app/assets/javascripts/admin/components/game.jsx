var React = require('react'),
    ReactDOM = require('react-dom'),
    Collapse = require('react-bootstrap').Collapse,
    Popover = require('react-bootstrap').Popover,
    Overlay = require('react-bootstrap').Overlay,
    classNames = require('classnames'),
    ScoreReports = require('./score_reports'),
    GamesStore = require('../stores/games_store'),
    LoadingMixin = require('../mixins/loading_mixin');

exports.NameCell = React.createClass({
  getInitialState() {
    var game = this.props.rowData;

    return {
      reportsOpen: game.reportsOpen || false
    };
  },

  _toggleCollapse(e) {
    e.nativeEvent.preventDefault();
    var game = this.props.rowData;
    var state = !this.state.reportsOpen;

    GamesStore.saveReportsState(game, state);
    this.setState({ reportsOpen: state });
  },

  render() {
    var game = this.props.rowData;
    var name = game.name;
    var reports = game.score_reports;

    if (reports.length == 0) {
      return( <span>{name}</span> );
    };

    return (
      <div>
        <a href="#" onClick={this._toggleCollapse}>
          {name + " "}
          <span className="badge">{reports.length}</span>
        </a>
        <Collapse in={this.state.reportsOpen}>
          <div>
            <ScoreReports reports={reports}/>
          </div>
        </Collapse>
      </div>
    );
  }
});

exports.ScoreCell = React.createClass({
  mixins: [LoadingMixin],

  getInitialState() {
    var game = this.props.rowData;

    return {
      show: false,
      homeScore: game.home_score,
      awayScore: game.away_score
    };
  },

  toggle(ev) {
    ev.preventDefault();
    this.setState({show: !this.state.show});
  },

  hide(ev) {
    if(ev){ ev.preventDefault(); }
    this.setState({ show: false });
  },

  _opened() {
    var game = this.props.rowData;

    this.setState({
      homeScore: game.home_score,
      awayScore: game.away_score
    });
  },

  _setFocus() {
    this.refs.input.focus();
  },

  updateScore(ev) {
    ev.preventDefault();
    var gameId = this.props.rowData.id;
    this._startLoading();

    $.ajax({
      url: 'games/' + gameId + '.json',
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        home_score: this.state.homeScore,
        away_score: this.state.awayScore
      },
      success: (response) => {
        this._finishLoading();
        this.hide();
        var game = response.game;
        var scroll = window.scrollY;
        GamesStore.updateGame(game);
        window.scrollTo(0, scroll);
        Admin.Flash.notice('Score updated')
      },
      error: (response) => {
        this._finishLoading();
        Admin.Flash.error('Error updating score');
      }
    })
  },

  render() {
    var game = this.props.rowData;
    var btnClasses = classNames('btn', 'btn-default', {'is-loading': this.state.isLoading});

    if (!game.has_teams) {
      return(<div></div>);
    };

    return (
      <div>
        <a href="#" ref="target" onClick={this.toggle}>
          {game.home_score} - {game.away_score}
        </a>

        <Overlay
          show={this.state.show}
          onHide={() => this.hide()}
          onEnter={this._opened}
          onEntered={this._setFocus}
          target={() => ReactDOM.findDOMNode(this.refs.target)}
          placement="top"
          rootClose={true}
        >
          <Popover id={"scoreForm#{game.id}"}>
            <h5>
              {game.name}
              <a href="#" className="pull-right" onClick={this.hide}>X</a>
            </h5>
            <form className="form-inline">
              <input type="number"
                     value={this.state.homeScore}
                     min='0'
                     className="form-control score-input"
                     onChange={ (e) => {
                       this.setState({homeScore: e.target.valueAsNumber})
                     }}
                     ref="input"/>
              <span> &mdash; </span>
              <input type="number"
                     value={this.state.awayScore}
                     min='0'
                     className="form-control score-input"
                     onChange={ (e) => {
                       this.setState({awayScore: e.target.valueAsNumber})
                     }}/>
              <button className={btnClasses} onClick={this.updateScore}>
                Save
              </button>
            </form>
          </Popover>
        </Overlay>
      </div>
    );
  }
});

exports.ConfirmedCell = React.createClass({
  render() {
    var game = this.props.rowData;
    var iconClass;
    var iconColor;

    if(game.confirmed) {
      iconClass = "fa fa-check";
      iconColor = "green";
    } else if(game.played) {
      iconClass = "fa fa-exclamation-circle";
      iconColor = 'orange';
    } else {
      iconClass = "fa fa-question-circle";
      iconColor ="#008B8B";
    };

    return (
      <i className={iconClass} style={{color: iconColor}}></i>
    );
  }
});
