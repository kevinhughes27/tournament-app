import { keys } from "lodash";
import CreateFieldMutation from "../../../mutations/CreateField";

class FieldImporter {
  component: React.Component;

  started: boolean;
  progress: number;
  total: number;
  completed: number;
  errors: { [key: number]: string; };

  constructor(component: React.Component) {
    this.component = component;

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
      await this.importField(row, i);
    }
  }

  private importField = async (row: any[], rowIdx: number) => {

    const variables = {
      name: row[0],
      lat: parseFloat(row[1]),
      long: parseFloat(row[2]),
      geoJson: row[3]
    };

    const result = await CreateFieldMutation.commit({input: variables});

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

export default FieldImporter;
