import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import DivisionEdit from "./DivisionEdit";

const query = gql`
  query DivisionEditQuery($divisionId: ID!) {
    division(id: $divisionId) {
      id
      name
      numTeams
      numDays
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
        handle
        description
      }
    }
  }
`;

interface Props extends RouteComponentProps<any> {}

class DivisionEditContainer extends React.Component<Props> {
  render() {
    const divisionId = this.props.match.params.divisionId;
    return renderQuery(query, {divisionId}, DivisionEdit);
  }
}

export default withRouter(DivisionEditContainer);
