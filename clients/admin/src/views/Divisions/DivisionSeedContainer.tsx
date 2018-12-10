import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { query } from "../../queries/DivisionSeedQuery";
import renderQuery from "../../helpers/renderQuery";
import DivisionSeed from "./DivisionSeed";

interface Props extends RouteComponentProps<any> {}

class DivisionSeedContainer extends React.Component<Props> {
  render() {
    const divisionId = this.props.match.params.divisionId;
    return renderQuery(query, {divisionId}, DivisionSeed, {fetchPolicy: "network-only"});
  }
}

export default withRouter(DivisionSeedContainer);
