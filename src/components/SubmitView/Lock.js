import ls from 'local-storage';
import React, { Component } from 'react';
import PinInput from 'react-pin-input';
import { checkPin } from '../../actions/checkPin';

const lockKey = 'locked';
const PIN_LENGTH = 4;

export default class Lock extends Component {
  state = {
    locked: ls.get(lockKey) !== false
  };

  unlock = () => {
    ls.set(lockKey, false);
    this.setState({ locked: false });
  };

  lock = () => {
    ls.set(lockKey, true);
    this.setState({ locked: true });
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
                checkPin(value).then(
                  valid => (valid ? this.unlock() : this.lock())
                );
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
