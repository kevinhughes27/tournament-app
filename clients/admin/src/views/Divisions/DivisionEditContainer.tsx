import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderQuery";
import { encodeId } from "../../helpers/relay";
import DivisionEdit from "./DivisionEdit";

interface Props extends RouteComponentProps<any> {}

class DivisionEditContainer extends React.Component<Props> {
  render() {
    const divisionId = encodeId("Division", this.props.match.params.divisionId);

    const query = graphql`
      query DivisionEditContainerQuery($divisionId: ID!) {
        division(id: $divisionId) {
          ...DivisionEdit_division
        }
      }
    `;

    return renderQuery(query, {divisionId}, DivisionEdit);
  }
}

export default withRouter(DivisionEditContainer);
