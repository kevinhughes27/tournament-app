import * as React from "react";
import gql from "graphql-tag";
import renderQuery from "../../helpers/renderQuery";
import DivisionList from "./DivisionList";

const query = gql`
  query DivisionListQuery {
    divisions {
      id
      name
      bracket {
        handle
      }
      teamsCount
      numTeams
      isSeeded
    }
  }
`;

class DivisionListContainer extends React.Component {
  render() {
    return renderQuery(query, {}, DivisionList);
  }
}

export default DivisionListContainer;
