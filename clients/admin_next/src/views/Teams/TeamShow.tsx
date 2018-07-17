import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Breadcrumbs from "../../components/Breadcrumbs";
import TeamForm from "./TeamForm";

const styles = {};

interface Props extends WithStyles<typeof styles> {
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

const StyledTeamShow = withStyles(styles)(TeamShow);

export default createFragmentContainer(StyledTeamShow, {
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
