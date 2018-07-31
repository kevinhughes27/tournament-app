import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import TextField from "@material-ui/core/TextField";
import MenuItem from "@material-ui/core/MenuItem";
import Bracket from "./Bracket";

interface Props {
  numTeams: number;
  numDays: number;
  bracketType: string;
  brackets: BracketPicker_brackets;
  setValue: (field: string, value: string) => void;
  onChange: (event: React.ChangeEvent<{}>) => void;
}

interface BracketOption {
  handle: string;
  name: string;
}

class BracketPicker extends React.Component<Props> {
  constructor(props: Props) {
    super(props);

    const value = this.props.bracketType;
    const options = this.props.brackets;

    const valueInOptions = options.find((b) => b.handle === value);

    if (!valueInOptions && options.length > 0) {
      const newValue = options[0].handle;
      this.props.setValue("bracketType", newValue);
    }
  }

  render() {
    const options = this.props.brackets;

    if (options.length > 0) {
      return (
        <div>
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
          {this.renderBracket()}
        </div>
      );
    } else {
      return <DisabledInput />;
    }
  }

  renderBracket = () => {
    const value  = this.props.bracketType;
    const bracket = this.props.brackets.find((b) => b.handle === value);

    if (bracket) {
      return <Bracket bracketTree={bracket.tree} />;
    } else {
      return null;
    }
  }
}

const Option = (option: BracketOption) => (
  <MenuItem key={option.handle} value={option.handle}>
    {option.name}
  </MenuItem>
);

const DisabledInput = () => (
  <TextField
      name="bracketType"
      label="No Brackets"
      margin="normal"
      fullWidth
      disabled={true}
  />
);

export default createFragmentContainer(BracketPicker, {
  brackets: graphql`
    fragment BracketPicker_brackets on Bracket @relay(plural: true) {
      handle
      name
      tree
    }
  `,
});
