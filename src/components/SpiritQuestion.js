import React, { Component } from 'react';
import { RadioButton, RadioButtonGroup } from 'material-ui/RadioButton';

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
        <RadioButtonGroup
          name={this.props.handle}
          defaultSelected={this.props.value.toString()}
          onChange={this.props.onChange}
        >
          <RadioButton value="1" label="Poor" />
          <RadioButton value="2" label="Not Good" />
          <RadioButton value="3" label="Good" />
          <RadioButton value="4" label="Very Good" />
          <RadioButton value="5" label="Excellent" />
        </RadioButtonGroup>
      </div>
    );
  }
}

export default SpiritQuestion;
