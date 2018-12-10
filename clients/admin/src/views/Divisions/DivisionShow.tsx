import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import Breadcrumbs from "../../components/Breadcrumbs";
import Structure from "./Structure";
import ActionMenu from "../../components/ActionMenu";
import SeedIcon from "@material-ui/icons/FormatListNumberedRtl";

interface Props extends RouteComponentProps<{}> {
  division: DivisionShowQuery_division;
}

class DivisionShow extends React.Component<Props> {
  render() {
    const division = this.props.division;

    return (
      <>
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
      </>
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

export default withRouter(DivisionShow);
