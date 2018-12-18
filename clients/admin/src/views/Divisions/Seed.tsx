import * as React from 'react';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import ClearIcon from '@material-ui/icons/Clear';

interface Props {
  team: DivisionSeedQuery_teams;
  onDelete: () => void;
}

class Seed extends React.Component<Props> {
  render() {
    const team = this.props.team;
    const style = {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      paddingLeft: 4,
      paddingRight: 4,
      height: 61
    };

    return (
      <span style={style}>
        <Typography variant="body1">{team.name}</Typography>
        <IconButton onClick={this.props.onDelete}>
          <ClearIcon color="disabled" />
        </IconButton>
      </span>
    );
  }
}

export default Seed;
