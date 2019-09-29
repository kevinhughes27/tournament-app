import * as React from 'react';
import {
  DragSource,
  DragSourceSpec,
  ConnectDragSource,
  DragSourceCollector
} from 'react-dnd';

import GameColor from '../GameColor';
import GameText from '../GameText';

interface Props {
  game: UnscheduledGame;
  connectDragSource?: ConnectDragSource;
  isDragging?: boolean;
}

const gameSource: DragSourceSpec<Props, {}> = {
  beginDrag(props: Props) {
    return props.game;
  }
};

interface CollectedProps {
  connectDragSource: ConnectDragSource;
  isDragging: boolean;
}

const collect: DragSourceCollector<CollectedProps, {}> = (connect, monitor) => {
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  };
};

export class Game extends React.Component<Props> {
  render() {
    const { connectDragSource, isDragging, game } = this.props;

    const color = GameColor(game);
    const style = {
      opacity: isDragging ? 0.5 : 1,
      backgroundColor: color,
      cursor: 'move'
    };

    return connectDragSource!(
      <div className="unscheduled-game" style={style}>
        <div className="body">{GameText(game, 90)}</div>
      </div>
    );
  }
}

export default DragSource('game', gameSource, collect)(Game);
