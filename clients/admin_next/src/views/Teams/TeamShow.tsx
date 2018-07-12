import * as React from "react";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Breadcrumbs from "../../components/Breadcrumbs";
import TeamForm from "./TeamForm";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  team: any;
  divisions: any;
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

export default withStyles(styles)(TeamShow);
