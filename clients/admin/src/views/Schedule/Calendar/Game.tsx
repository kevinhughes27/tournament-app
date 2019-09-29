import * as React from 'react';
import {
  DragSource,
  DragSourceSpec,
  ConnectDragSource,
  DragSourceCollector
} from 'react-dnd';

import GameColor from '../GameColor';
import Position from './Position';
import GameText from '../GameText';

interface Props {
  game: ScheduledGame;
  error: boolean;
  gameLength: number;
  startResize: (game: ScheduledGame) => void;
  unschedule: (game: ScheduledGame) => void;
  connectDragSource?: ConnectDragSource;
  isDragging?: boolean;
}

const gameSource: DragSourceSpec<Props, {}> = {
  beginDrag(props) {
    return props.game;
  },

  endDrag(props, monitor) {
    if (monitor.didDrop()) {
      props.unschedule(props.game);
    }
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

class Game extends React.Component<Props> {
  private gameRef: React.RefObject<HTMLDivElement>;

  constructor(props: Props) {
    super(props);
    this.gameRef = React.createRef();
  }

  onMouseDown = (ev: React.MouseEvent<HTMLElement>) => {
    const game = this.props.game;
    const ref = this.gameRef.current!;
    const bounds = ref.getBoundingClientRect();

    if (bounds.bottom - ev.clientY < 10) {
      this.props.startResize(game);
      ev.preventDefault();
    }
  };

  render() {
    const {
      connectDragSource,
      isDragging,
      game,
      error,
      gameLength
    } = this.props;
    const position = new Position(game.startTime, gameLength);
    const color = GameColor(game);
    const style = {
      opacity: isDragging ? 0.75 : 1,
      backgroundColor: color,
      ...position.inlineStyles()
    };

    let klass = 'game';
    if (error) {
      klass += ' error';
    }

    return connectDragSource!(
      <div className={klass} style={style} onMouseDown={this.onMouseDown}>
        <div ref={this.gameRef} className="body">
          {GameText(game, gameLength)}
        </div>
      </div>
    );
  }
}

export default DragSource('game', gameSource, collect)(Game);
