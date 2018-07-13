import * as React from "react";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Breadcrumbs from "../../components/Breadcrumbs";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  team: any;
}

class TeamShow extends React.Component<Props> {
  render() {
    const { team } = this.props;

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/teams", text: "Teams"},
            {text: team.name}
          ]}
        />
      </div>
    );
  }
}

export default withStyles(styles)(TeamShow);
