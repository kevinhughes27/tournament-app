import * as React from "react";
import * as moment from "moment";
import { sortBy, filter, map } from "lodash";
import {
  DropTarget,
  DropTargetSpec,
  ConnectDropTarget,
  DropTargetCollector,
  DropTargetMonitor
} from "react-dnd";

import Settings from "./Settings";
import ScheduledGame from "./ScheduledGame";
import DropOverlay from "./DropOverlay";
import { showNotice } from "../../../components/Notice";

import environment from "../../../relay";
import ScheduleGameMutation from "../../../mutations/ScheduleGame";
import UnscheduleGameMutation from "../../../mutations/UnscheduleGame";

interface Props {
  date: string;
  fieldId: string;
  games: Game[];
  isOver?: boolean;
  connectDropTarget?: ConnectDropTarget;
}

interface State {
  hoverTime: moment.Moment | null;
  resizingGame: Game | null;
  gameLength: number;
  gameErrors: Set<ID>;
}

const target: DropTargetSpec<Props> = {
  hover({}, monitor, component: FieldColumn) {
    component.hover(monitor);
  },

  drop({}, monitor, component: FieldColumn) {
    if (monitor) {
      const game = monitor.getItem() as Game;
      component.schedule(game);
    }
  }
};

const collect: DropTargetCollector = (connect, monitor) => {
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

  hover = (monitor?: DropTargetMonitor) => {
    const ref = this.columnRef.current;

    if (ref && monitor) {
      const rect = ref.getBoundingClientRect();
      const percentY = (monitor.getClientOffset().y - rect.top) / rect.height;
      const hours = percentY * (Settings.scheduleLength()) + Settings.scheduleStart;
      const slot = Settings.scheduleInc * Math.round(hours * 60 / Settings.scheduleInc);
      const hoverTime = moment(this.props.date, "LL").minutes(slot);

      this.setState({
        gameLength: Settings.defaultGameLength,
        hoverTime
      });
    }
  }

  schedule = (game: Game) => {
    const { hoverTime, gameLength } = this.state;

    if (hoverTime) {
      const startTime = hoverTime.format("YYYY-MM-DDTHH:mm");
      const endTime = hoverTime.add(gameLength, "minutes").format("YYYY-MM-DDTHH:mm");

      ScheduleGameMutation.commit(
        environment,
        {
          fieldId: this.props.fieldId,
          startTime,
          endTime
        },
        game,
        this.mutationComplete,
        this.mutationError
      );
    }
  }

  unschedule = (game: Game) => {
    UnscheduleGameMutation.commit(
      environment,
      game,
      this.mutationComplete,
      this.mutationError
    );
  }

  startResize = (game: Game) => {
    this.setState({resizingGame: game});
  }

  onMouseMove = (ev: React.MouseEvent<HTMLElement>) => {
    const game = this.state.resizingGame;
    const column = this.columnRef.current;

    if (game && column) {
      const rect = column.getBoundingClientRect();
      const percentY = (ev.clientY - rect.top) / rect.height;
      const hours = percentY * (Settings.scheduleLength()) + Settings.scheduleStart;
      const slot = Settings.scheduleInc * Math.round(hours * 60 / Settings.scheduleInc);
      const endTime = moment(this.props.date, "LL").minutes(slot);
      const startTime = moment.parseZone(game.startTime).format("YYYY-MM-DDTHH:mm");

      if (moment.duration(endTime.diff(startTime)).asMinutes() < Settings.scheduleInc) {
        return;
      }

      const gameLength = moment.duration(endTime.diff(startTime)).asMinutes();

      this.setState({gameLength});
    }
  }

  endResize = () => {
    const game = this.state.resizingGame;

    if (game) {
      const { gameLength } = this.state;
      const startTime = moment.parseZone(game.startTime).format("YYYY-MM-DDTHH:mm");
      const endTime = moment.parseZone(game.startTime).add(gameLength, "minutes").format("YYYY-MM-DDTHH:mm");

      ScheduleGameMutation.commit(
        environment,
        {
          fieldId: game.field.id,
          startTime,
          endTime,
        },
        game,
        this.mutationComplete,
        this.mutationError
      );

      Settings.update({defaultGameLength: this.state.gameLength});
      Settings.save();
    }

    this.setState({resizingGame: null});
  }

  mutationComplete = (result: ScheduleGame) => {
    const errors = this.state.gameErrors;

    if (result.success) {
      errors.delete(result.game.id);
    } else {
      errors.add(result.game.id);
    }

    this.setState({gameErrors: errors});

    showNotice(result.message);
  }

  mutationError = (error: Error | undefined) => {
    showNotice(error && error.message || "Something went wrong");
  }

  render() {
    const { connectDropTarget, date, games } = this.props;
    const filteredGames = filter(games, (g) => moment(date, "LL").isSame(g.startTime, "day"));
    const sortedGames = sortBy(filteredGames, (g) => moment(g.startTime));

    if (connectDropTarget) {
      return connectDropTarget(
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
    } else {
      return null;
    }
  }

  renderScheduledGame = (game: Game) => {
    const hasError = this.state.gameErrors.has(game.id);
    const gameLength = (game === this.state.resizingGame)
      ? this.state.gameLength
      : moment.duration(moment(game.endTime).diff(game.startTime)).asMinutes();

    return (
      <ScheduledGame
        key={game.id}
        game={game}
        error={hasError}
        gameLength={gameLength}
        startResize={this.startResize}
        unschedule={this.unschedule}
      />
    );
  }

  renderOverlay() {
    if (this.props.isOver && this.state.hoverTime) {
      const start = this.state.hoverTime.format();
      const length = this.state.gameLength;
      return <DropOverlay startTime={start} length={length}/>;
    } else {
      return null;
    }
  }
}

export default DropTarget("game", target, collect)(FieldColumn);
