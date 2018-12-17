import * as React from 'react';
import TextField from '@material-ui/core/TextField';
import MenuItem from '@material-ui/core/MenuItem';

interface Props {
  teamId?: string;
  teams: DivisionSeedQuery['teams'];
  onChange: (event: React.ChangeEvent<{ value: string }>) => void;
}

interface TeamOption {
  id: string;
  name: string;
}

class TeamPicker extends React.Component<Props> {
  render() {
    const { teamId, teams } = this.props;
    const options = teams.filter(t => t.id === teamId || !t.seed);

    return (
      <TextField
        name="teamId"
        margin="dense"
        variant="outlined"
        fullWidth
        select
        value={this.props.teamId || ''}
        onChange={this.props.onChange}
      >
        {options.map(option => Option(option))}
      </TextField>
    );
  }
}

const Option = (option: TeamOption) => (
  <MenuItem key={option.id} value={option.id}>
    {option.name}
  </MenuItem>
);

export default TeamPicker;
