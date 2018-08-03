class TeamImporter {
  csvData: string;
  override: string;

  total: number;
  completed: number;
  errors: number[];

  tick: () => void;

  constructor(csvData: string, override: string) {
    this.csvData = csvData;
    this.override = override;

    this.total = 10;
    this.completed = 0;
    this.errors = [];

    this.tick = () => {};
  }

  start = () => {
    setInterval(() => {
      this.completed = this.completed + 1;
      this.tick();
    }, 500);
  }

  setTick = (callback: () => void) => {
    this.tick = callback;
  }

  progress = () => {
    return ((this.errors.length + this.completed) / this.total) * 100;
  }
}

export default TeamImporter;
