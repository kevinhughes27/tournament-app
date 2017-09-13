import React, { Component } from 'react';
import PinInput from 'react-pin-input';

const PIN_LENGTH = 4;

const validate = pin => {
  return true;
};

export default class Lock extends Component {
  state = {
    locked: true
  };

  unlock = () => {
    this.setState({ locked: false });
  };

  lock = () => {
    this.setState({ locked: true });
  };

  updatePin = (value, index) => {
    let pin = this.state.pin;

    if (index >= pin.length) {
      pin[index] = value;
    } else {
    }
  };

  render() {
    if (this.state.locked) {
      return (
        <div className="lock-screen">
          <div style={{ textAlign: 'center' }}>
            <h3>Enter PIN to Unlock:</h3>
            <PinInput
              length={PIN_LENGTH}
              onComplete={value => {
                validate(value) ? this.unlock() : this.lock();
              }}
            />
          </div>
        </div>
      );
    } else {
      return this.props.children;
    }
  }
}
