import * as React from 'react';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import { sortBy } from 'lodash';

interface Seed {
  seed: number | null;
  name: string;
}

interface Props {
  teams: ReadonlyArray<Seed>;
}

class Seeds extends React.Component<Props> {
  render() {
    const teams = sortBy(this.props.teams, t => t.seed);

    return (
      <div
        style={{ minWidth: '140px', marginLeft: '20px', marginRight: '20px' }}
      >
        <Table>
          {this.renderHeader()}
          <TableBody>{teams.map(this.renderRow)}</TableBody>
        </Table>
      </div>
    );
  }

  renderHeader = () => {
    return (
      <TableHead>
        <TableRow>
          <TableCell>Seed</TableCell>
          <TableCell>Team</TableCell>
        </TableRow>
      </TableHead>
    );
  };

  renderRow = (team: Seed) => {
    return (
      <TableRow key={team.name}>
        <TableCell>{team.seed}</TableCell>
        <TableCell>{team.name}</TableCell>
      </TableRow>
    );
  };
}

export default Seeds;
