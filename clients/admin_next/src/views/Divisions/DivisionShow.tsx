import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import Structure from "./Structure";
import ActionButton from "../../components/ActionButton";

interface Props extends RouteComponentProps<{}> {
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
        <ActionButton icon="edit" onClick={() => this.props.history.push(`/divisions/${division.id}/edit`)}/>
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

export default createFragmentContainer(withRouter(DivisionShow), {
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
