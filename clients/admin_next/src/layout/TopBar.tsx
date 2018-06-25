import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { TopBar as styles } from "../assets/jss/styles";

import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import IconButton from "@material-ui/core/IconButton";
import MenuIcon from "@material-ui/icons/Menu";
import UserMenu from "./UserMenu";

interface Props extends WithStyles<typeof styles> {
  openNav: (event: React.SyntheticEvent<{}>) => void;
}

class TopBar extends React.Component<Props> {
  public render() {
    const { classes } = this.props;

    return (
      <AppBar position="static">
        <Toolbar>
          <IconButton className={classes.menuButton} aria-label="Menu" onClick={this.props.openNav}>
            <MenuIcon />
          </IconButton>
          <Typography variant="title" className={classes.title}>
            Ultimate Tournament
          </Typography>
          <UserMenu />
        </Toolbar>
      </AppBar>
    );
  }
}

export default withStyles(styles)(TopBar);
