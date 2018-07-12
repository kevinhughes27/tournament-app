import * as React from "react";
import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import { withRouter, RouteComponentProps } from "react-router-dom";

import Loader from "../../components/Loader";
import TeamShow from "./TeamShow";

interface Props extends RouteComponentProps<any> {}

class TeamShowContainer extends React.Component<Props> {
  render() {
    const teamId = this.props.match.params.teamId;

    const query = graphql`
      query TeamShowContainerQuery($teamId: ID!) {
        team(id: $teamId) {
          id
          name
          email
          division {
            id
            name
          }
          seed
        }
        divisions {
          ...DivisionPicker_divisions
        }
      }
    `;

    const render = ({error, props}: any) => {
      if (error) {
        return <div>{error.message}</div>;
      } else if (props) {
        return <TeamShow team={props.team} divisions={props.divisions}/>;
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

export default withRouter(TeamShowContainer);
