import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { SideBar as styles } from "../assets/jss/styles";

import SwipeableDrawer from "@material-ui/core/SwipeableDrawer";
import NavItems from "./NavItems";

interface Props extends WithStyles<typeof styles> {
  open: boolean;
  handleOpen: (event: React.SyntheticEvent<{}>) => void;
  handleClose: (event: React.SyntheticEvent<{}>) => void;
}

class SideBar extends React.Component<Props> {
  render() {
    return (
      <SwipeableDrawer
        open={this.props.open}
        onClose={this.props.handleClose}
        onOpen={this.props.handleOpen}
      >
        <div
          tabIndex={0}
          role="button"
          onClick={this.props.handleClose}
          onKeyDown={this.props.handleClose}
        >
          <NavItems />
        </div>
      </SwipeableDrawer>
    );
  }
}

export default withStyles(styles)(SideBar);
