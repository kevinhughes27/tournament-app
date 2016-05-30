var React = require('react'),
    ReactDOM = require('react-dom'),
    Modal = require('react-bootstrap').Modal,
    confirmable = require('react-confirm').confirmable,
    createConfirmation = require('react-confirm').createConfirmation;

const ConfirmModal = React.createClass({
  render() {
    var show = this.props.show;
    var proceed = this.props.proceed;
    var dismiss = this.props.dismiss;
    var title = this.props.title;
    var message = this.props.message;

    return (
      <Modal onHide={dismiss} show={show}>
        <Modal.Header closeButton onClick={() => cancel()}>
          <Modal.Title>{title}</Modal.Title>
        </Modal.Header>

        <Modal.Body>
          {message}
        </Modal.Body>

        <Modal.Footer>
          <button className="btn btn-default" onClick={() => dismiss()}>Cancel</button>
          <button className="btn btn-danger" onClick={() => proceed()}>Confirm</button>
        </Modal.Footer>
      </Modal>
    );
  }
});

export default confirmable(ConfirmModal);
