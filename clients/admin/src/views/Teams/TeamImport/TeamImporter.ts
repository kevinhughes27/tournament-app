import { keys } from "lodash";
import CreateTeamMutation from "../../../mutations/CreateTeam";

class TeamImporter {
  component: React.Component;
  divisions: TeamImport_divisions;

  started: boolean;
  progress: number;
  total: number;
  completed: number;
  errors: { [key: number]: string; };

  constructor(component: React.Component, divisions: TeamImport_divisions) {
    this.component = component;
    this.divisions = divisions;

    this.started = false;
    this.progress = 0;
    this.total = 1;
    this.completed = 0;
    this.errors = {};
  }

  start = (data: string[][]) => {
    this.started = true;
    this.total = data.length;
    this.component.forceUpdate();
    this.import(data);
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
      const fieldErrors = result.userErrors || [];
      const fullMessage = fieldErrors.map((e) => e.field + " " + e.message).join(", ");
      this.errors[rowIdx] = fullMessage;
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
