import * as React from "react";
import Position from "./Position";

interface Props {
  startTime: string;
  length: number;
}

class DropOverlay extends React.Component<Props> {
  render() {
    const { startTime, length } = this.props;
    const position = new Position(startTime, length);
    const styles = {
      opacity: 0.5,
      backgroundColor: "black",
      ...position.inlineStyles()
    };

    return <div className="game" style={styles} />;
  }
}

export default DropOverlay;
