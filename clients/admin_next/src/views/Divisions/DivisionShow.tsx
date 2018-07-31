import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import Structure from "./Structure";

interface Props {
  division: DivisionShow_division;
}

class DivisionShow extends React.Component<Props> {
  render() {
    const division = this.props.division;

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/divisions", text: "Divisions"},
            {text: division.name}
          ]}
        />
        {this.renderDescription()}
        <Structure games={division.games} bracketTree={division.bracketTree} />
      </div>
    );
  }

  renderDescription = () => {
    const division = this.props.division;
    const bracket = division.bracket;

    return (
      <div style={{paddingLeft: 20}}>
        <p>{bracket.name}</p>
        <p>{bracket.description}</p>
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
