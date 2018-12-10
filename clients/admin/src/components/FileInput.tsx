import * as React from "react";
import Button from "@material-ui/core/Button";

interface Props {
  name: string;
  value: string;
  accept: string;
  buttonText: string;
  onChange: (event: React.ChangeEvent<HTMLInputElement>) => void;
}

class FileInput extends React.Component<Props> {
  render() {
    const prettyFileName = this.props.value.replace("C:\\fakepath\\", "");

    return (
      <>
        <input
          id={this.props.name}
          name={this.props.name}
          accept={this.props.accept}
          style={{display: "none"}}
          type="file"
          value={this.props.value}
          onChange={this.props.onChange}
        />
        <label htmlFor={this.props.name}>
          <Button variant="contained" component="span">
            {this.props.buttonText}
          </Button>
        </label>
        <span style={{paddingLeft: 20}}>
          {prettyFileName}
        </span>
      </>
    );
  }
}

export default FileInput;
