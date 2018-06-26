import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";

import { RelayProp } from 'react-relay';

import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

import { TeamsQuery } from '../__relay_artifacts__/TeamsQuery.graphql';

const styles = {};

interface Props extends WithStyles<typeof styles> {
  relay: RelayProp,
  teams: TeamsQuery;
}

class TeamsList extends React.Component {
  public render() {
    const { classes, teams } = this.props;

    return (
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>ID</TableCell>
            <TableCell>Name</TableCell>
            <TableCell>Seed</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {teams.map(t => {
            return (
              <TableRow key={t.id}>
                <TableCell>{t.id}</TableCell>
                <TableCell>{t.name}</TableCell>
                <TableCell>{t.seed}</TableCell>
              </TableRow>
            );
          })}
        </TableBody>
      </Table>
    );
  }
}

export default withStyles(styles)(TeamsList);
