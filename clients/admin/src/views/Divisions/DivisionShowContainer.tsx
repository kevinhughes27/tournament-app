import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import DivisionShow from "./DivisionShow";

export const query = gql`
  query DivisionShowQuery($divisionId: ID!) {
    division(id: $divisionId) {
      id
      name
      games {
        pool
        homePrereq
        homeName
        awayPrereq
        awayName
      }
      bracketTree
      bracket {
        name
        description
      }
    }
  }
`;

interface Props extends RouteComponentProps<any> {}

class DivisionShowContainer extends React.Component<Props> {
  render() {
    const divisionId = this.props.match.params.divisionId;
    return renderQuery(query, {divisionId}, DivisionShow);
  }
}

export default withRouter(DivisionShowContainer);
