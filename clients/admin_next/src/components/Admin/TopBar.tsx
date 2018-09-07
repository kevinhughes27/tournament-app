import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { TopBar as styles } from "../../assets/jss/styles";

import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import IconButton from "@material-ui/core/IconButton";
import MenuIcon from "@material-ui/icons/Menu";
import UserMenu from "./UserMenu";

interface Props extends WithStyles<typeof styles> {
  openNav: (event: React.SyntheticEvent<{}>) => void;
  viewer: UserMenu_viewer;
}

class TopBar extends React.Component<Props> {
  render() {
    const { classes } = this.props;

    return (
      <AppBar position="static">
        <Toolbar>
          <IconButton id="side-bar" className={classes.menuButton} onClick={this.props.openNav}>
            <MenuIcon />
          </IconButton>
          <Typography variant="title" className={classes.title}>
            Ultimate Tournament
          </Typography>
          <UserMenu viewer={this.props.viewer} />
        </Toolbar>
      </AppBar>
    );
  }
}

export default withStyles(styles)(TopBar);
