var React = require('react'),
    ReactDOM = require('react-dom'),
    Collapse = require('react-bootstrap').Collapse,
    Modal = require('react-bootstrap').Modal,
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

    var nameClasses = classNames({'subdued': !game.has_teams});

    if (reports.length == 0) {
      return( <span className={nameClasses}>{name}</span> );
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

  open(ev) {
    ev.preventDefault();
    this.setState({show: true});
  },

  close(ev) {
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
      url: 'games/' + gameId,
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        home_score: this.state.homeScore,
        away_score: this.state.awayScore
      },
      success: (response) => {
        this._finishLoading();
        this.close();
        Admin.Flash.notice('Score updated')
      },
      error: (response) => {
        if(response.status == 422) {
          // pop confirm modal, re-submit with force param
          debugger;
        };

        this._finishLoading();
        Admin.Flash.error('Error updating score');
      }
    })
  },

  render() {
    var game = this.props.rowData;

    if (!game.has_teams) {
      return(<div></div>);
    };

    var text;
    if(game.has_score) {
      text = `${game.home_score} - ${game.away_score}`;
    } else {
      text = <i className="fa fa-plus-square-o"></i>;
    }

    var btnClasses = classNames('btn', 'btn-primary', {'is-loading': this.state.isLoading});

    return (
      <div>
        <a href="#" ref="target" onClick={this.open}>
          {text}
        </a>

        <Modal
          show={this.state.show}
          onHide={this.close}
          onEnter={this._opened}
          onEntered={this._setFocus}>
          <Modal.Header closeButton>
            <Modal.Title>{game.name}</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <form>
              <div className='row'>
                <div className="col-md-5 col-sm-5 col-xs-5">
                  <input type="number"
                         value={this.state.homeScore}
                         placeholder={game.home}
                         min='0'
                         className="form-control score-input"
                         onChange={ (e) => {
                           this.setState({homeScore: e.target.valueAsNumber})
                         }}
                         ref="input"/>
                </div>
                <div className='col-md-1 col-sm-1 col-xs-1 text-center'>
                  <span> &mdash; </span>
                </div>
                <div className="col-md-6 col-sm-6 col-xs-5">
                  <input type="number"
                         value={this.state.awayScore}
                         placeholder={game.away}
                         min='0'
                         className="form-control score-input"
                         onChange={ (e) => {
                           this.setState({awayScore: e.target.valueAsNumber})
                         }}/>
                </div>
              </div>
            </form>
          </Modal.Body>
          <Modal.Footer>
            <button className="btn btn-default" onClick={this.close}>Cancel</button>
            <button className={btnClasses} onClick={this.updateScore}>
              Save
            </button>
          </Modal.Footer>
        </Modal>
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
