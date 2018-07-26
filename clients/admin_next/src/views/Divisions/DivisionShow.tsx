import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";

interface Props {
  division: Division;
}

class DivisionShow extends React.Component<Props> {
  render() {
    const { division } = this.props;

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/divisions", text: "Divisions"},
            {text: division.name}
          ]}
        />
      </div>
    );
  }
}

export default createFragmentContainer(DivisionShow, {
  division: graphql`
    fragment DivisionShow_division on Division {
      id
      name
    }
  `
});
