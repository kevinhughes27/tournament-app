import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
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

    return renderQuery(query, {divisionId}, DivisionShow);
  }
}

export default withRouter(DivisionShowContainer);
