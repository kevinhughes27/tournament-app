import * as React from 'react';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';

interface Seed {
  seed: string;
  name: string;
}

interface Props {
  pool: string;
  teams: Seed[];
}

class Pool extends React.Component<Props> {
  render() {
    const { pool, teams } = this.props;

    return (
      <div
        style={{ minWidth: '140px', marginLeft: '20px', marginRight: '20px' }}
      >
        <Table>
          {this.renderHeader(pool)}
          <TableBody>{teams.map(this.renderRow)}</TableBody>
        </Table>
      </div>
    );
  }

  renderHeader = (pool: string) => {
    return (
      <TableHead>
        <TableRow>
          <TableCell>Pool {pool}</TableCell>
        </TableRow>
      </TableHead>
    );
  };

  renderRow = (team: Seed) => {
    let text = `${team.seed}`;
    if (team.name && team.name !== team.seed) {
      text = `${team.seed} - ${team.name}`;
    }

    return (
      <TableRow key={team.seed}>
        <TableCell>{text}</TableCell>
      </TableRow>
    );
  };
}

export default Pool;
