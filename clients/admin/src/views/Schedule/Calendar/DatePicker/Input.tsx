import * as React from 'react';
import Button from '@material-ui/core/Button';

class Input extends React.Component<any> {
  render() {
    return <Button onClick={this.props.onClick}>{this.props.value}</Button>;
  }
}

export default Input;
