import React, { Component } from 'react';
import Radio, { RadioGroup } from 'material-ui/Radio';
import { FormControl, FormControlLabel } from 'material-ui/Form';

class SpiritQuestion extends Component {
  render() {
    return (
      <div>
        <h2>
          {this.props.question}
        </h2>
        <p>
          {this.props.example}
        </p>
        <FormControl component="fieldset" required>
          <RadioGroup
            name={this.props.handle}
            value={this.props.value.toString()}
            onChange={this.props.onChange}
          >
            <FormControlLabel value="1" control={<Radio />} label="Poor" />
            <FormControlLabel value="2" control={<Radio />} label="Not Good" />
            <FormControlLabel value="3" control={<Radio />} label="Good" />
            <FormControlLabel value="4" control={<Radio />} label="Very Good" />
            <FormControlLabel value="5" control={<Radio />} label="Excellent" />
          </RadioGroup>
        </FormControl>
      </div>
    );
  }
}

export default SpiritQuestion;
