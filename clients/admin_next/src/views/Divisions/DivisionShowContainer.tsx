import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";

import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import render from "../../helpers/renderHelper";

import DivisionShow from "./DivisionShow";

interface Props extends RouteComponentProps<any> {}

class DivisionShowContainer extends React.Component<Props> {
  render() {
    const divisionId = this.props.match.params.divisionId;

    const query = graphql`
      query DivisionShowContainerQuery($divisionId: ID!) {
        division(id: $divisionId) {
          ...DivisionShow_division
        }
      }
    `;

    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{divisionId}}
        render={render(DivisionShow)}
      />
    );
  }
}

export default withRouter(DivisionShowContainer);
