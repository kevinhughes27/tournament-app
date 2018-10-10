import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import Structure from "./Structure";
import ActionMenu from "../../components/ActionMenu";
import SeedIcon from "@material-ui/icons/FormatListNumberedRtl";

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
        <ActionMenu
          actions={[
            {
              icon: <SeedIcon />,
              name: "seed",
              handler: () => this.props.history.push(`/divisions/${division.id}/seed`)
            },
            {
              icon: "edit",
              name: "edit",
              handler: () => this.props.history.push(`/divisions/${division.id}/edit`)
            }
          ]}
        />
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
