import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderQuery";
import DivisionList from "./DivisionList";

const query = graphql`
  query DivisionListContainerQuery {
    divisions {
      ...DivisionList_divisions
    }
  }
`;

class DivisionListContainer extends React.Component {
  render() {
    return renderQuery(query, {}, DivisionList);
  }
}

export default DivisionListContainer;
