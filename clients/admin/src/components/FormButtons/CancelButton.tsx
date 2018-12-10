import * as React from 'react';
import { FormButtons as styles } from '../../assets/jss/styles';
import { withStyles, WithStyles } from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import { Link } from 'react-router-dom';

interface Props extends WithStyles<typeof styles> {
  onClick?: () => void;
  link?: string;
  disabled: boolean;
}

class CancelButton extends React.Component<Props> {
  render() {
    const { disabled, classes } = this.props;

    if (this.props.onClick) {
      return (
        <Button
          variant="contained"
          color="secondary"
          onClick={this.props.onClick}
          className={classes.cancelButton}
          classes={{ disabled: classes.disabled }}
          disabled={disabled}
        >
          Cancel
        </Button>
      );
    } else if (this.props.link) {
      return (
        <Button
          variant="contained"
          color="secondary"
          className={classes.cancelButton}
          classes={{ disabled: classes.disabled }}
          disabled={disabled}
        >
          <Link to={this.props.link} className={classes.cancelLink}>
            Cancel
          </Link>
        </Button>
      );
    } else {
      return null;
    }
  }
}

export default withStyles(styles)(CancelButton);
