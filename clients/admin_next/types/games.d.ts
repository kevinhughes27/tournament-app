interface Game {
  readonly id: string;
  readonly homePrereq: string;
  readonly awayPrereq: string;
  readonly homePoolSeed: number | null;
  readonly awayPoolSeed: number | null;
  readonly pool: string | null;
  readonly bracketUid: string | null;
  readonly round: number;
  readonly startTime: any | null;
  readonly endTime: any | null;
  readonly field: ({
    readonly id: string;
    readonly name: string;
  }) | null;
  readonly division: {
    readonly id: string;
    readonly name: string;
  };
}

interface ScheduledGame extends Game {
  readonly startTime: string;
  readonly endTime: string;
  readonly field: {
    readonly id: string;
    readonly name: string;
  };
}

interface UnscheduledGame extends Game {
  readonly startTime: null;
  readonly endTime: null;
  readonly field: null;
}

interface PoolGame extends Game {
  readonly pool: string;
  readonly homePoolSeed: number;
  readonly awayPoolSeed: number;
}

interface BracketGame extends Game {
  readonly bracketUid: string;
}
