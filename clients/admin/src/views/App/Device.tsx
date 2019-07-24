import * as React from 'react';

interface Props {
  src: string;
}

class Device extends React.Component<Props> {
  render() {
    return (
      <div className="device-column">
        <div className="device">
          <div className="device-content">
            <iframe
              src={this.props.src}
              title="player-app-in-phone"
              scrolling="no"
              className="device-iframe"
            />
          </div>
        </div>
      </div>
    );
  }
}

export default Device;
