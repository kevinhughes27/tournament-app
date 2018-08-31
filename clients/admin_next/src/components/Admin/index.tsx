import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Admin as styles } from "../../assets/jss/styles";
import { QueryRenderer, graphql } from "react-relay";
import TopBar from "./TopBar";
import SideBar from "./SideBar";
import Notice from "../Notice";
import Routes from "../../views/routes";
import environment from "../../relay";

interface State {
  navOpen: boolean;
}

class Admin extends React.Component<Props, State> {
  state = {
    navOpen: false,
  };

  openNav = () => {
    this.setState({navOpen: true});
  }

  closeNave = () => {
    this.setState({navOpen: false});
  }

  render() {
    const { classes } = this.props;
    return (
      <QueryRenderer
        environment={environment}
        query={graphql`
          query AdminQuery {
            viewer {
              id
              name
              email
            }
          }
        `}
        render={({props}) => {      
          return(
            <div className={classes.root}>
              <TopBar 
                openNav={this.openNav}
                viewer={props && props.viewer}
              />
              <SideBar
                open={this.state.navOpen}
                handleOpen={this.openNav}
                handleClose={this.closeNave}
              />
              <Notice />
              <Routes/>
            </div>
           );    
         }}
      />
    );
  }
}

export default withStyles(styles)(Admin);
