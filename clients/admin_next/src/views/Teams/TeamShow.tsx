import * as React from "react";
import { Link } from "react-router-dom";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Typography from "@material-ui/core/Typography";

const styles = {
  title: {
    padding: 10,
    paddingLeft: 20
  }
};

interface Props extends WithStyles<typeof styles> {
  team: any;
}

class TeamShow extends React.Component<Props> {
  render() {
    const { team, classes } = this.props;

    return (
      <div>
        <Typography variant="subheading" className={classes.title}>
          <Link to={`/teams`}>Teams</Link> / {team.name}
        </Typography>
        <p>
          {team.name}
        </p>
      </div>
    );
  }
}

export default withStyles(styles)(TeamShow);
