import * as React from "react";
import { ActionButton as styles } from "../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Zoom from "@material-ui/core/Zoom";
import Button from "@material-ui/core/Button";
import AddIcon from "@material-ui/icons/Add";
import EditIcon from "@material-ui/icons/Edit";
import SaveIcon from "@material-ui/icons/Save";

const icons = {
  add: <AddIcon />,
  edit: <EditIcon />,
  save: <SaveIcon />
};

interface Props extends WithStyles<typeof styles> {
  icon: "add" | "edit" | "save";
  onClick: () => void;
}

class ActionButton extends React.Component<Props> {
  render() {
    const { classes, theme } = this.props;

    const transitionDuration = {
      enter: theme!.transitions.duration.enteringScreen,
      exit: theme!.transitions.duration.leavingScreen,
    };

    return (
      <Zoom
        in={true}
        timeout={transitionDuration}
        style={{transitionDelay: `${transitionDuration.exit}ms`}}
        unmountOnExit
      >
        <Button
          variant="fab"
          color="primary"
          className={classes.fab}
          onClick={this.props.onClick}
        >
          {icons[this.props.icon]}
        </Button>
      </Zoom>
    );
  }
}

export default withStyles(styles, {withTheme: true})(ActionButton);
