import * as React from "react";
import Breadcrumbs from "../../components/Breadcrumbs";
import TeamForm from "./TeamForm";

interface Props {
  divisions: Division[];
}

class TeamNew extends React.Component<Props> {
  render() {
    const { divisions } = this.props;

    const newTeam = {
      id: "",
      name: "",
      email: "",
      division: {
        id: "",
        name: "",
        bracket: {
          handle: "",
          name: "",
          description: "",
          numTeams: 0,
          numDays: 0,
          games: "",
          places: "",
          tree: ""
        },
        bracketTree: "",
        games: [],
        teamsCount: 0,
        numTeams: 0,
        isSeeded: false
      },
      seed: 0
    };

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/teams", text: "Teams"},
            {text: "New"}
          ]}
        />
        <TeamForm team={newTeam} divisions={divisions}/>
      </div>
    );
  }
}

export default TeamNew;
