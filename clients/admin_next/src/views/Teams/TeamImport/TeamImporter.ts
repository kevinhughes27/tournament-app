import csv from "csv";
import { keys, isEqual } from "lodash";
import CreateTeamMutation from "../../../mutations/CreateTeam";

const HEADER = ["Name", "Email", "Division", "Seed"];

class TeamImporter {
  csvData: string;
  divisions: TeamImport_divisions;

  total: number;
  completed: number;
  errors: any;

  tick: () => void;

  constructor(csvData: string, divisions: TeamImport_divisions) {
    this.csvData = csvData;
    this.divisions = divisions;

    this.total = 10;
    this.completed = 0;
    this.errors = {};

    this.tick = () => { return; };
  }

  setTick = (callback: () => void) => {
    this.tick = callback;
  }

  start = () => {
    csv.parse(this.csvData, (err: string, data: any[]) => {
      if (err) {
        return;
      }

      const header = data[0];

      // invalid csv
      if (!isEqual(header, HEADER)) {
        return;
      }

      const rows = data.slice(1);

      this.total = rows.length;

      rows.forEach(this.importTeam);
    });
  }

  progress = () => {
    return ((keys(this.errors).length + this.completed) / this.total) * 100;
  }

  private importTeam = (row: any[], rowIdx: number) => {
    const division = this.divisions.find((d) => d.name === row[2]);

    const variables = {
      name: row[0],
      email: row[1],
      divisionId: division && division.id,
      seed: parseInt(row[3], 10)
    };

    CreateTeamMutation.commit({input: variables}).then((result) => {
      if (result.success) {
        this.completed += 1;
      } else {
        this.errors[rowIdx] = result.userErrors;
      }

      this.tick();
    });
  }
}

export default TeamImporter;
