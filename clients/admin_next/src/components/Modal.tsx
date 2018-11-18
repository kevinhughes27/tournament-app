import * as React from "react";
import { Modal as styles } from "../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { default as UiModal } from "@material-ui/core/Modal";
import Typography from "@material-ui/core/Typography";
import IconButton from "@material-ui/core/IconButton";
import CloseIcon from "@material-ui/icons/Close";

interface Props extends WithStyles<typeof styles> {
  open: boolean;
  onClose: () => void;
  title: string;
}

class Modal extends React.Component<Props> {
  render() {
    const { classes } = this.props;

    return (
      <UiModal open={this.props.open} onClose={this.props.onClose}>
        <div className={classes.paper} style={{maxWidth: "90%", width: 540}}>
          <div className={classes.title}>
            <Typography variant="h6">
              {this.props.title}
            </Typography>
            <IconButton onClick={this.props.onClose}>
              <CloseIcon />
            </IconButton>
          </div>
          {this.props.children}
        </div>
      </UiModal>
    );
  }
}

export default withStyles(styles)(Modal);
