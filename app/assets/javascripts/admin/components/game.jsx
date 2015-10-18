var React = require('react'),
    ReactDOM = require('react-dom'),
    Collapse = require('react-bootstrap').Collapse,
    Popover = require('react-bootstrap').Popover,
    Overlay = require('react-bootstrap').Overlay,
    classNames = require('classnames'),
    ScoreReports = require('./score_reports'),
    GamesStore = require('../stores/games_store');

exports.NameCell = React.createClass({
  getInitialState() {
    return {
      reportsOpen: false
    };
  },

  _toggleCollapse(e) {
    e.nativeEvent.preventDefault();
    this.setState({ reportsOpen: !this.state.reportsOpen });
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
  getInitialState() {
    var game = this.props.rowData;

    return {
      show: false,
      isLoading: false,
      homeScore: game.home_score,
      awayScore: game.away_score
    };
  },

  toggle() {
    this.setState({show: !this.state.show});
  },

  hide() {
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

  _startLoading() {
    Turbolinks.ProgressBar.start()
    this.setState({isLoading: true});
  },

  _finishLoading() {
    Turbolinks.ProgressBar.done()
    this.setState({isLoading: false});
  },

  updateScore() {
    this._startLoading();

    var game = this.props.rowData;

    $.ajax({
      url: 'games/' + game.id + '.json',
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        home_score: this.state.homeScore,
        away_score: this.state.awayScore
      },
      success: (response) => {
        this._finishLoading();
        this.hide(response);
        GamesStore.updateGame(response.game);
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

    return (
      <div>
        <a href="#" ref="target" onClick={this.toggle}>
          {game.score}
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
              <a href="#" className="pull-right" onClick={() => this.hide() }>X</a>
            </h5>
            <form className="form-inline">
              <input type="number"
                     value={this.state.homeScore}
                     className="form-control score-input"
                     onChange={ (e) => {
                       this.setState({homeScore: e.target.valueAsNumber})
                     }}
                     ref="input"/>
              <span> &mdash; </span>
              <input type="number"
                     value={this.state.awayScore}
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
