import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import TextField from "@material-ui/core/TextField";
import MenuItem from "@material-ui/core/MenuItem";

interface Props {
  divisionId: string;
  divisions: DivisionPicker_divisions;
  onChange: (event: React.ChangeEvent<{}>) => void;
  helperText: any;
}

interface DivisionOption {
  id: string;
  name: string;
}

class DivisionPicker extends React.Component<Props> {
  render() {
    const options = this.props.divisions;

    return (
      <TextField
        name="divisionId"
        label="Division"
        margin="normal"
        fullWidth
        select
        value={this.props.divisionId}
        onChange={this.props.onChange}
        helperText={this.props.helperText}
      >
        {options.map((option) => Option(option))}
      </TextField>
    );
  }
}

const Option = (option: DivisionOption) => (
  <MenuItem key={option.id} value={option.id}>
    {option.name}
  </MenuItem>
);

export default createFragmentContainer(DivisionPicker, {
  divisions: graphql`
    fragment DivisionPicker_divisions on Division @relay(plural: true) {
      id
      name
    }
  `,
});
