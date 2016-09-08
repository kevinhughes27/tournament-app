import React from 'react';
import ReactDOM from 'react-dom';
import {Collapse, Modal} from 'react-bootstrap';
import classNames from 'classnames';
import confirm from './confirm';

class UpdateScoreModal extends React.Component {
  constructor(props) {
    super(props);

    this.open = this.open.bind(this);
    this.close = this.close.bind(this);
    this.opened = this.opened.bind(this);
    this.setFocus = this.setFocus.bind(this);
    this.submit = this.submit.bind(this);

    let game = this.props.game;

    this.state = {
      show: false,
      isLoading: false,
      resolve: this.props.resolve,
      homeScore: game.home_score,
      awayScore: game.away_score
    };
  }

  getDefaultProps() {
    return {
      resolve: false,
      linkClass: ''
    }
  }

  open(ev) {
    ev.preventDefault();
    this.setState({show: true});
  }

  close(ev) {
    if(ev){ ev.preventDefault(); }
    this.setState({ show: false });
  }

  opened() {
    let game = this.props.game;

    this.setState({
      homeScore: game.home_score,
      awayScore: game.away_score
    });
  }

  setFocus() {
    this.refs.input.focus();
  }

  submit(ev) {
    ev.preventDefault();
    this.updateScore()
  }

  updateScore(force = false) {
    let gameId = this.props.game.id;
    this.setState({isLoading: true});

    $.ajax({
      url: 'games/' + gameId,
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        home_score: this.state.homeScore,
        away_score: this.state.awayScore,
        resolve: this.state.resolve,
        force: force
      },
      success: (response) => {
        this.setState({isLoading: false});
        this.close();
        Admin.Flash.notice('Score updated')
      },
      error: (response) => {
        this.setState({isLoading: false});

        if(response.status == 422) {
          this.close();
          this.confirmUpdateScore();
        } else {
          Admin.Flash.error('Error updating score');
        }
      }
    })
  }

  confirmUpdateScore() {
    confirm({
      title: "Confirm Update Score",
      message: "This update will change the teams in games that come after it\
      and some of those games have been scored. If you update this\
      score those games will be reset. This cannot be undone."
    }).then(
      (result) => {
        this.updateScore(true);
      },
      (result) => {
        console.log('cancelled');
      }
    );
  }

  render() {
    let {game, linkText, linkClass} = this.props;
    let btnClasses = classNames('btn', 'btn-primary', {'is-loading': this.state.isLoading});

    return (
      <div>
        <button className={linkClass} onClick={this.open}>
          {linkText}
        </button>

        <Modal
          show={this.state.show}
          onHide={this.close}
          onEnter={this.opened}
          onEntered={this.setFocus}>
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
            <button className={btnClasses} onClick={this.submit}>
              Save
            </button>
          </Modal.Footer>
        </Modal>
      </div>
    );
  }
}

module.exports = UpdateScoreModal;
