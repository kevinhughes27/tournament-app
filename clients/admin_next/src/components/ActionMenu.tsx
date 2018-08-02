import * as React from "react";
import { ActionButton as styles } from "../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Zoom from "@material-ui/core/Zoom";

import SpeedDial from "@material-ui/lab/SpeedDial";
import SpeedDialIcon from "@material-ui/lab/SpeedDialIcon";
import SpeedDialAction from "@material-ui/lab/SpeedDialAction";

interface Props extends WithStyles<typeof styles> {
  actions: ReadonlyArray<{
    icon: JSX.Element;
    name: string;
    handler: () => void;
  }>;
}

interface State {
  open: boolean;
}

class ActionMenu extends React.Component<Props, State> {
  state = {
    open: false
  };

  handleOpen = () => {
    this.setState({open: true});
  }

  handleClose = () => {
    this.setState({open: false});
  }

  handleClick = () => {
    this.setState({open: !this.state.open});
  }

  render() {
    const { classes, theme, actions } = this.props;

    if (theme) {
      const transitionDuration = {
        enter: theme.transitions.duration.enteringScreen,
        exit: theme.transitions.duration.leavingScreen,
      };

      let isTouch;
      if (typeof document !== 'undefined') {
        isTouch = 'ontouchstart' in document.documentElement;
      }

      return (
        <Zoom
          in={true}
          timeout={transitionDuration}
          style={{transitionDelay: `${transitionDuration.exit}ms`}}
          unmountOnExit
        >
          <SpeedDial
            ariaLabel="Menu"
            className={classes.fab}
            icon={<SpeedDialIcon />}
            onClick={this.handleClick}
            onClose={this.handleClose}
            onMouseEnter={isTouch ? undefined : this.handleOpen}
            onMouseLeave={isTouch ? undefined : this.handleClose}
            open={this.state.open}
          >
            {actions.map((action) => (
              <SpeedDialAction
                key={action.name}
                icon={action.icon}
                tooltipTitle={action.name}
                onClick={action.handler}
              />
            ))}
          </SpeedDial>
        </Zoom>
      );
    } else {
      return null;
    }
  }
}

export default withStyles(styles, {withTheme: true})(ActionMenu);
