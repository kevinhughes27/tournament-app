import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import TeamForm from "./TeamForm";

interface Props {
  team: Team;
  divisions: Division[];
}

class TeamShow extends React.Component<Props> {
  render() {
    const { team, divisions } = this.props;

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/teams", text: "Teams"},
            {text: team.name}
          ]}
        />
        <TeamForm team={team} divisions={divisions}/>
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
