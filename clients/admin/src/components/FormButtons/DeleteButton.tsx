import * as React from 'react';
import { FormButtons as styles } from '../../assets/jss/styles';
import { withStyles, WithStyles } from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import TrashIcon from '@material-ui/icons/Delete';
import CircularProgress from '@material-ui/core/CircularProgress';

interface Props extends WithStyles<typeof styles> {
  onClick?: () => void;
  disabled: boolean;
  submitting: boolean;
}

class DeleteButton extends React.Component<Props> {
  render() {
    const { disabled, submitting, classes } = this.props;

    return (
      <Button
        variant="contained"
        color="secondary"
        onClick={this.props.onClick}
        className={classes.deleteButton}
        classes={{ disabled: classes.disabled }}
        disabled={disabled || submitting}
      >
        {this.buttonContent()}
      </Button>
    );
  }

  buttonContent = () => {
    const { submitting } = this.props;

    if (submitting) {
      return <CircularProgress size={20} />;
    } else {
      return <TrashIcon />;
    }
  };
}

export default withStyles(styles)(DeleteButton);
