import * as React from "react";
import { Link } from "react-router-dom";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Typography from "@material-ui/core/Typography";
import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

const styles = {
  title: {
    padding: 10,
    paddingLeft: 20
  }
};

interface Props extends WithStyles<typeof styles> {
  teams: any;
}

const Row = (t: any) => (
  <TableRow hover key={t.id}>
    <TableCell>
      <Link to={`/teams/${t.id}`}>
        {t.name}
      </Link>
    </TableCell>
    <TableCell>{t.division.name}</TableCell>
    <TableCell>{t.seed}</TableCell>
  </TableRow>
);

class TeamList extends React.Component<Props> {
  render() {
    const { teams, classes } = this.props;

    return (
      <div>
        <Typography variant="subheading" className={classes.title}>
          Teams
        </Typography>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Division</TableCell>
              <TableCell>Seed</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {teams.map(Row)}
          </TableBody>
        </Table>
      </div>
    );
  }
}

export default withStyles(styles)(TeamList);
