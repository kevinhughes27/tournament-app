import csv from "csv";
import { keys, isEqual } from "lodash";
import CreateTeamMutation from "../../../mutations/CreateTeam";

const HEADER = ["Name", "Email", "Division", "Seed"];

class TeamImporter {
  component: React.Component;
  divisions: TeamImport_divisions;

  started: boolean;

  progress: number;
  total: number;
  completed: number;
  errors: any;

  constructor(component: React.Component, divisions: TeamImport_divisions) {
    this.component = component;
    this.divisions = divisions;

    this.started = false;

    this.progress = 0;
    this.total = 1;
    this.completed = 0;
    this.errors = {};
  }

  start = (csvData: string) => {
    this.started = true;
    this.component.forceUpdate();
    this.parse(csvData);
  }

  private parse = (csvData: string) => {
    csv.parse(csvData, (err: string, data: any[]) => {
      if (err) { return; }

      const header = data[0];
      if (!isEqual(header, HEADER)) { return; } // invalid csv

      const rows = data.slice(1);

      this.total = rows.length;

      this.import(rows);
    });
  }

  private import = async (rows: any[]) => {
    for (const [i, row] of rows.entries()) {
      await this.importTeam(row, i);
    }
  }

  private importTeam = async (row: any[], rowIdx: number) => {
    const division = this.divisions.find((d) => d.name === row[2]);

    const variables = {
      name: row[0],
      email: row[1],
      divisionId: division && division.id,
      seed: parseInt(row[3], 10)
    };

    const result = await CreateTeamMutation.commit({input: variables});

    if (result.success) {
      this.completed += 1;
    } else {
      this.errors[rowIdx] = result.userErrors;
    }

    this.updateProgress();
  }

  private updateProgress = () => {
    const errorCount = keys(this.errors).length;
    this.progress = ((errorCount + this.completed) / this.total) * 100;
    this.component.forceUpdate();
  }
}

export default TeamImporter;
