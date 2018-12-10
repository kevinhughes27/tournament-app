import * as React from 'react';
import LinearProgress from '@material-ui/core/LinearProgress';

class BracketLoader extends React.Component {
  render() {
    return (
      <div style={{ paddingTop: 33, paddingBottom: 34 }}>
        <LinearProgress color="secondary" />
      </div>
    );
  }
}

export default BracketLoader;
