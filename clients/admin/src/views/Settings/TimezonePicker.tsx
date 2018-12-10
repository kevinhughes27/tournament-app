import * as React from 'react';
import TextField from '@material-ui/core/TextField';
import MenuItem from '@material-ui/core/MenuItem';
import Timezones from './Timezones';

interface Props {
  timezone: string;
  onChange: (event: React.ChangeEvent<{}>) => void;
}

class TimezonePicker extends React.Component<Props> {
  render() {
    return (
      <TextField
        name="timezone"
        label="Timezone"
        margin="normal"
        fullWidth
        select
        value={this.props.timezone}
        onChange={this.props.onChange}
      >
        {Timezones.map(zone => Option(zone[0], zone[1]))}
      </TextField>
    );
  }
}

const Option = (name: string, handle: string) => (
  <MenuItem key={name} value={handle}>
    {name}
  </MenuItem>
);

export default TimezonePicker;
