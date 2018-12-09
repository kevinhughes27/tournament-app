import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import DivisionSeed from "./DivisionSeed";

const query = gql`
  query DivisionSeedQuery($divisionId: ID!) {
    division(id: $divisionId) {
      id
      name
      teams {
        id
        name
        seed
      }
    }
  }
`;

interface Props extends RouteComponentProps<any> {}

class DivisionSeedContainer extends React.Component<Props> {
  render() {
    const divisionId = this.props.match.params.divisionId;
    return renderQuery(query, {divisionId}, DivisionSeed);
  }
}

export default withRouter(DivisionSeedContainer);
