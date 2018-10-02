import * as React from "react";
import Radio from "@material-ui/core/Radio";
import RadioGroup from "@material-ui/core/RadioGroup";
import FormControlLabel from "@material-ui/core/FormControlLabel";
import FormControl from "@material-ui/core/FormControl";
import FormLabel from "@material-ui/core/FormLabel";

interface Props {
  value: string;
  onChange: (event: React.ChangeEvent<{}>) => void;
}

class ConfirmOptions extends React.Component<Props> {
  render() {
    return (
      <FormControl component="fieldset" style={{marginTop: 20}}>
        <FormLabel component="legend">Score Confirmation Setting</FormLabel>
        <RadioGroup
          name="gameConfirmSetting"
          value={this.props.value}
          onChange={this.props.onChange}
        >
          <FormControlLabel value="single" onChange={this.props.onChange} control={<Radio />} label="Single" />
          <FormControlLabel value="multiple" onChange={this.props.onChange} control={<Radio />} label="Multiple" />
        </RadioGroup>
      </FormControl>
    );
  }
}

export default ConfirmOptions;
