import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import TextField from "@material-ui/core/TextField";
import MenuItem from "@material-ui/core/MenuItem";

interface Props {
  numTeams: number;
  numDays: number;
  bracketType: string;
  brackets: BracketPicker_brackets;
  onChange: (event: React.ChangeEvent<{}>) => void;
}

interface BracketOption {
  handle: string;
  name: string;
}

class BracketPicker extends React.Component<Props> {
  render() {
    const options = this.props.brackets;

    return (
      <TextField
        name="bracketType"
        label="Bracket"
        margin="normal"
        fullWidth
        select
        value={this.props.bracketType}
        onChange={this.props.onChange}
      >
        {options.map((option) => Option(option))}
      </TextField>
    );
  }
}

const Option = (option: BracketOption) => (
  <MenuItem key={option.handle} value={option.handle}>
    {option.name}
  </MenuItem>
);

export default createFragmentContainer(BracketPicker, {
  brackets: graphql`
    fragment BracketPicker_brackets on Bracket @relay(plural: true) {
      handle
      name
    }
  `,
});
