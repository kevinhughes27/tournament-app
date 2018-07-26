import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import TextField from "@material-ui/core/TextField";
import MenuItem from "@material-ui/core/MenuItem";

interface Props {
  divisionId: string;
  divisions: Division[];
  onChange: (event: React.ChangeEvent<{}>) => void;
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
      >
        {options.map((option: {id: string, name: string}) => Option(option))}
      </TextField>
    );
  }
}

const Option = (option: {id: string, name: string}) => (
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
