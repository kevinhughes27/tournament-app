import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import Pools from "./Pools";
import Bracket from "./Bracket";

interface Props {
  division: DivisionShow_division;
}

class DivisionShow extends React.Component<Props> {
  render() {
    const { division } = this.props;
    const bracket = division.bracket;

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/divisions", text: "Divisions"},
            {text: division.name}
          ]}
        />
        <div style={{paddingLeft: 20}}>
          <p>
            <strong>{bracket.name}</strong>
          </p>
          <p>{bracket.description}</p>
        </div>
        <Pools division={division} />
        <Bracket bracketTree={division.bracketTree} />
      </div>
    );
  }
}

export default createFragmentContainer(DivisionShow, {
  division: graphql`
    fragment DivisionShow_division on Division {
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
  `
});
