import React from 'react';
import ReactDOM from 'react-dom';
import {Modal} from 'react-bootstrap';
import {confirmable, createConfirmation} from 'react-confirm';

class ConfirmModal extends React.Component {
  render() {
    let show = this.props.show;
    let proceed = this.props.proceed.bind(this);
    let dismiss = this.props.dismiss.bind(this);
    let title = this.props.title;
    let message = this.props.message;

    return (
      <Modal onHide={dismiss} show={show}>
        <Modal.Header closeButton onClick={() => cancel()}>
          <Modal.Title>{title}</Modal.Title>
        </Modal.Header>

        <Modal.Body>
          {message}
        </Modal.Body>

        <Modal.Footer>
          <button className="btn btn-default" onClick={this.dismiss()}>Cancel</button>
          <button className="btn btn-danger" onClick={this.proceed()}>Confirm</button>
        </Modal.Footer>
      </Modal>
    );
  }
}

module.exports = confirmable(ConfirmModal);
