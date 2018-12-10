import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { query } from "../../queries/DivisionShowQuery";
import renderQuery from "../../helpers/renderQuery";
import DivisionShow from "./DivisionShow";

interface Props extends RouteComponentProps<any> {}

class DivisionShowContainer extends React.Component<Props> {
  render() {
    const divisionId = this.props.match.params.divisionId;
    return renderQuery(query, {divisionId}, DivisionShow);
  }
}

export default withRouter(DivisionShowContainer);
