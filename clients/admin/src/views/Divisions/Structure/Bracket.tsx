import * as React from 'react';
import Paper from '@material-ui/core/Paper';
import renderBracketGraph from './BracketGraph';

interface Props {
  bracketTree: string;
}

class Bracket extends React.Component<Props> {
  bracketRef: React.RefObject<HTMLDivElement>;

  constructor(props: Props) {
    super(props);
    this.bracketRef = React.createRef();
  }

  componentDidMount() {
    const node = this.bracketRef.current;
    const bracketTree = this.props.bracketTree;

    if (node) {
      renderBracketGraph(node, bracketTree);
    }
  }

  componentDidUpdate() {
    const node = this.bracketRef.current;
    const bracketTree = this.props.bracketTree;

    if (node) {
      renderBracketGraph(node, bracketTree);
    }
  }

  render() {
    return (
      <Paper className="bracketContainer" elevation={1}>
        <div id="bracketGraph" ref={this.bracketRef} />
      </Paper>
    );
  }
}

export default Bracket;
