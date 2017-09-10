import React, { Component } from 'react';
import { Radio, RadioGroup } from 'material-ui/Radio';

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
        <RadioGroup
          name={this.props.handle}
          defaultSelected={this.props.value.toString()}
          onChange={this.props.onChange}
        >
          <Radio value="1" label="Poor" />
          <Radio value="2" label="Not Good" />
          <Radio value="3" label="Good" />
          <Radio value="4" label="Very Good" />
          <Radio value="5" label="Excellent" />
        </RadioGroup>
      </div>
    );
  }
}

export default SpiritQuestion;
