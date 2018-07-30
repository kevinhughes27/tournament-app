import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import TeamForm from "./TeamForm";

interface Props {
  team: TeamShow_team;
  divisions: DivisionPicker_divisions;
}

class TeamShow extends React.Component<Props> {
  render() {
    const { team, divisions } = this.props;

    const input = {
      ...team,
      divisionId: team.division && team.division.id
    };

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/teams", text: "Teams"},
            {text: team.name}
          ]}
        />
        <TeamForm input={input} divisions={divisions}/>
      </div>
    );
  }
}

export default createFragmentContainer(TeamShow, {
  team: graphql`
    fragment TeamShow_team on Team {
      id
      name
      email
      division {
        id
        name
      }
      seed
    }
  `
});
