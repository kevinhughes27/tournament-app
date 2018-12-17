import * as React from 'react';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import TeamPicker from './TeamPicker';
import runMutation from '../../helpers/runMutation';
import CreateSeed from '../../mutations/CreateSeed';
import { range } from 'lodash';

interface Props {
  division: DivisionSeedQuery_division;
  teams: DivisionSeedQuery['teams'];
}

class Seeds extends React.Component<Props> {
  updateSeed = (teamId: string, rank: number) => {
    const input = {
      input: {
        divisionId: this.props.division.id,
        teamId,
        rank
      }
    };

    runMutation(CreateSeed, input);
  };

  render() {
    const division = this.props.division;
    const seeds = range(1, division.numTeams + 1);

    return (
      <div
        style={{ minWidth: '140px', marginLeft: '20px', marginRight: '20px' }}
      >
        <Table>
          {this.renderHeader()}
          <TableBody>{seeds.map(rank => this.renderRow(rank))}</TableBody>
        </Table>
      </div>
    );
  }

  renderHeader = () => {
    return (
      <TableHead>
        <TableRow>
          <TableCell>Team</TableCell>
          <TableCell>Rank</TableCell>
        </TableRow>
      </TableHead>
    );
  };

  renderRow = (rank: number) => {
    const { division, teams } = this.props;
    const team = division.teams.find(t => t.seed === rank);

    return (
      <TableRow key={rank}>
        <TableCell>
          <TeamPicker
            teamId={team && team.id}
            teams={teams}
            onChange={ev => this.updateSeed(ev.target.value, rank)}
          />
        </TableCell>
        <TableCell>{rank}</TableCell>
      </TableRow>
    );
  };
}

export default Seeds;
