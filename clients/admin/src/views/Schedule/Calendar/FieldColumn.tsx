import * as React from 'react';
import moment from 'moment';
import { sortBy, filter, map } from 'lodash';
import {
  DropTarget,
  DropTargetSpec,
  ConnectDropTarget,
  DropTargetCollector,
  DropTargetMonitor
} from 'react-dnd';

import Settings from '../Settings';
import Game from './Game';
import DropOverlay from './DropOverlay';

import runMutation from '../../../helpers/runMutation';
import ScheduleGameMutation from '../../../mutations/ScheduleGame';
import UnscheduleGameMutation from '../../../mutations/UnscheduleGame';

interface Props {
  date: string;
  fieldId: string;
  games: ScheduledGame[];
  isOver?: boolean;
  connectDropTarget?: ConnectDropTarget;
}

interface State {
  hoverTime: moment.Moment | null;
  resizingGame: ScheduledGame | null;
  gameLength: number;
  gameErrors: Set<string>;
}

const target: DropTargetSpec<Props> = {
  hover(_, monitor, component: FieldColumn) {
    component.hover(monitor);
  },

  drop(_, monitor, component: FieldColumn) {
    const game = monitor.getItem() as ScheduledGame;
    component.schedule(game);
  }
};

interface CollectedProps {
  isOver: boolean;
  connectDropTarget: ConnectDropTarget;
}

const collect: DropTargetCollector<CollectedProps> = (connect, monitor) => {
  return {
    connectDropTarget: connect.dropTarget(),
    isOver: monitor.isOver()
  };
};

class FieldColumn extends React.Component<Props, State> {
  columnRef: React.RefObject<HTMLDivElement>;

  constructor(props: Props) {
    super(props);

    this.columnRef = React.createRef();

    this.state = {
      hoverTime: null,
      resizingGame: null,
      gameLength: Settings.defaultGameLength,
      gameErrors: new Set()
    };
  }

  hover = (monitor: DropTargetMonitor) => {
    const ref = this.columnRef.current!;

    const rect = ref.getBoundingClientRect();
    const percentY = (monitor.getClientOffset()!.y - rect.top) / rect.height;
    const hours = percentY * Settings.scheduleLength() + Settings.scheduleStart;
    const slot =
      Settings.scheduleInc * Math.round((hours * 60) / Settings.scheduleInc);
    const hoverTime = moment(this.props.date, 'LL').minutes(slot);

    this.setState({
      gameLength: Settings.defaultGameLength,
      hoverTime
    });
  };

  schedule = (game: ScheduledGame | UnscheduledGame) => {
    const { hoverTime, gameLength } = this.state;

    if (hoverTime) {
      const gameId = game.id;
      const fieldId = this.props.fieldId;
      const startTime = hoverTime.format('YYYY-MM-DDTHH:mm');
      const endTime = hoverTime
        .add(gameLength, 'minutes')
        .format('YYYY-MM-DDTHH:mm');

      runMutation(
        ScheduleGameMutation,
        { input: { gameId, fieldId, startTime, endTime } },
        { failed: this.mutationFailed }
      );
    }
  };

  unschedule = (game: ScheduledGame | UnscheduledGame) => {
    runMutation(UnscheduleGameMutation, { input: { gameId: game.id } });
  };

  startResize = (game: ScheduledGame) => {
    this.setState({ resizingGame: game });
  };

  onMouseMove = (ev: React.MouseEvent<HTMLElement>) => {
    const game = this.state.resizingGame;
    const column = this.columnRef.current!;

    if (game) {
      const rect = column.getBoundingClientRect();
      const percentY = (ev.clientY - rect.top) / rect.height;
      const hours =
        percentY * Settings.scheduleLength() + Settings.scheduleStart;
      const slot =
        Settings.scheduleInc * Math.round((hours * 60) / Settings.scheduleInc);
      const endTime = moment(this.props.date, 'LL').minutes(slot);
      const startTime = moment
        .parseZone(game.startTime)
        .format('YYYY-MM-DDTHH:mm');

      if (
        moment.duration(endTime.diff(startTime)).asMinutes() <
        Settings.scheduleInc
      ) {
        return;
      }

      const gameLength = moment.duration(endTime.diff(startTime)).asMinutes();

      this.setState({ gameLength });
    }
  };

  endResize = () => {
    const game = this.state.resizingGame;

    if (game) {
      const gameId = game.id;
      const fieldId = game.field.id;
      const { gameLength } = this.state;
      const startTime = moment
        .parseZone(game.startTime)
        .format('YYYY-MM-DDTHH:mm');
      const endTime = moment
        .parseZone(game.startTime)
        .add(gameLength, 'minutes')
        .format('YYYY-MM-DDTHH:mm');

      runMutation(
        ScheduleGameMutation,
        { input: { gameId, fieldId, startTime, endTime } },
        { failed: this.mutationFailed }
      );

      Settings.update({ defaultGameLength: this.state.gameLength });
      Settings.save();
    }

    this.setState({ resizingGame: null });
  };

  mutationFailed = (r: MutationResult) => {
    const result = (r as any) as SchedulingResult;
    const errors = this.state.gameErrors;

    if (result.success) {
      errors.delete(result.game.id);
    } else {
      errors.add(result.game.id);
    }

    this.setState({ gameErrors: errors });
  };

  render() {
    const { connectDropTarget, date, games } = this.props;
    const filteredGames = filter(games, g =>
      moment(date, 'LL').isSame(g.startTime, 'day')
    );
    const sortedGames = sortBy(filteredGames, g => moment(g.startTime));

    return connectDropTarget!(
      <div className="field-column">
        <div
          className="games"
          ref={this.columnRef}
          onMouseMove={this.onMouseMove}
          onMouseLeave={this.endResize}
          onMouseUp={this.endResize}
        >
          {map(sortedGames, this.renderScheduledGame)}
          {this.renderOverlay()}
        </div>
      </div>
    );
  }

  renderScheduledGame = (game: ScheduledGame) => {
    const hasError = this.state.gameErrors.has(game.id);
    const gameLength =
      game === this.state.resizingGame
        ? this.state.gameLength
        : moment
            .duration(moment(game.endTime).diff(game.startTime))
            .asMinutes();

    return (
      <Game
        key={game.id}
        game={game}
        error={hasError}
        gameLength={gameLength}
        startResize={this.startResize}
        unschedule={this.unschedule}
      />
    );
  };

  renderOverlay() {
    if (this.props.isOver && this.state.hoverTime) {
      const start = this.state.hoverTime.format();
      const length = this.state.gameLength;
      return <DropOverlay startTime={start} length={length} />;
    } else {
      return null;
    }
  }
}

export default DropTarget('game', target, collect)(FieldColumn);
