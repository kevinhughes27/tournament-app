import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";

import environment from "../../relay";
import { graphql, QueryRenderer } from "react-relay";
import render from "../../helpers/renderHelper";

import FieldShow from "./FieldShow";

interface Props extends RouteComponentProps<any> {}

class FieldShowContainer extends React.Component<Props> {
  render() {
    const fieldId = this.props.match.params.fieldId;

    const query = graphql`
      query FieldShowContainerQuery($fieldId: ID!) {
        map {
        ...FieldShow_map
        }
        field(id: $fieldId) {
          ...FieldShow_field
        }
        fields {
          ...FieldShow_fields
        }
      }
`;

    return (
      <QueryRenderer
        environment={environment}
        query={query}
        variables={{fieldId}}
        render={render(FieldShow)}
      />
    );
  }
}

export default withRouter(FieldShowContainer);
