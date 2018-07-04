import * as React from "react";
import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import { withRouter, RouteComponentProps } from "react-router-dom";

import Loader from "../../components/Loader";
import View from "./show";

interface Props extends RouteComponentProps<any> {}

class Container extends React.Component<Props> {
  render() {
    const teamId = this.props.match.params.teamId;

    const query = graphql`
      query showContainerQuery($teamId: ID!) {
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
        return <View team={props.team}/>;
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

export default withRouter(Container);
