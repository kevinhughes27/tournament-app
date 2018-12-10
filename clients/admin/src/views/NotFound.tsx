import * as React from 'react';
import BlankSlate from '../components/BlankSlate';

class NotFound extends React.Component {
  render() {
    return (
      <BlankSlate>
        <h3>There's nothing here!</h3>
        <p>Please make sure the url is correct.</p>
      </BlankSlate>
    );
  }
}

export default NotFound;
