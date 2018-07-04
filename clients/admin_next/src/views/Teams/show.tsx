import * as React from "react";
import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import { Link, withRouter, RouteComponentProps } from "react-router-dom";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Typography from "@material-ui/core/Typography";

import Loader from "../../components/Loader";

const styles = {
  title: {
    padding: 10,
    paddingLeft: 20
  }
};

interface ViewProps extends WithStyles<typeof styles> {
  team: any;
}

class View extends React.Component<ViewProps> {
  render() {
    const { team, classes } = this.props;

    return (
      <div>
        <Typography variant="subheading" className={classes.title}>
          <Link to={`/teams`}>Teams</Link> / {team.name}
        </Typography>
        <p>
          {team.name}
        </p>
      </div>
    );
  }
}

const StyledView = withStyles(styles)(View);

interface Props extends RouteComponentProps<any> {}

class TeamView extends React.Component<Props> {
  render() {
    const teamId = this.props.match.params.teamId;

    const query = graphql`
      query showQuery($teamId: ID!) {
        team(id: $teamId) {
          id
          name
          division {
            id
            name
          }
          seed
        }
      }
    `;

    const render = ({error, props}: any) => {
      if (error) {
        return <div>{error.message}</div>;
      } else if (props) {
        return <StyledView team={props.team}/>;
      } else {
        return <Loader />;
      }
    };

    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{teamId}}
        render={render}
      />
    );
  }
}

export default withRouter(TeamView);
