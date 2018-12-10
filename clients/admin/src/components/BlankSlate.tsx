import * as React from 'react';
import { withStyles, WithStyles } from '@material-ui/core/styles';
import { BlankSlate as styles } from '../assets/jss/styles';

interface Props extends WithStyles<typeof styles> {}

class BlankSlate extends React.Component<Props> {
  render() {
    const { children, classes } = this.props;

    return (
      <div className={classes.container}>
        <span>{children}</span>
      </div>
    );
  }
}

export default withStyles(styles)(BlankSlate);
