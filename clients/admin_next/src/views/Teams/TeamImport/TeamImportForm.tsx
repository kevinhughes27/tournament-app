import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions } from "formik";
import FileInput from "../../../components/FileInput";
import csv from "csv";
import { isEqual } from "lodash";
import Button from "@material-ui/core/Button";
import ImportIcon from "@material-ui/icons/GroupAdd";

interface Props {
  startImport: (csvData: string) => void;
}

interface State {
  csvData: string;
  error: string;
}

class TeamImportForm extends React.Component<Props, State> {
  state = {
    csvData: "",
    error: ""
  };

  initialValues = () => {
    return {
      csvFile: ""
    };
  }

  fileChanged = (ev: React.ChangeEvent<HTMLInputElement>) => {
    this.setState({csvData: "", error: ""});

    const files = ev.target.files;

    if (files && files.length === 1) {
      const file = files[0];
      const reader = new FileReader();

      reader.readAsText(file);
      reader.onload = () => {
        const csvData = reader.result;

        csv.parse(csvData, (err: string, data: any[]) => {
          if (err) {
            this.setState({error: "Invalid CSV file"});
            return;
          }

          const header = data[0];
          const expectedHeader = ["Name", "Email", "Division", "Seed"];

          if (!isEqual(header, expectedHeader)) {
            this.setState({error: "Invalid CSV Columns"});
            return;
          }

          this.setState({csvData});
        });
      };
    }
  }

  onSubmit = ({}: FormikValues, actions: FormikActions<FormikValues>) => {
    actions.resetForm();
    this.props.startImport(this.state.csvData);
  }

  render() {
    return (
      <Formik
        initialValues={this.initialValues()}
        onSubmit={this.onSubmit}
        render={this.renderForm}
      />
    );
  }

  renderForm = (formProps: FormikProps<FormikValues>) => {
    const {
      values,
      handleChange,
      handleSubmit,
      isSubmitting,
    } = formProps;

    return (
      <form onSubmit={handleSubmit}>
        <FileInput
          name="csvFile"
          value={values.csvFile}
          accept=".csv"
          buttonText="CSV File"
          onChange={(ev) => {
            handleChange(ev);
            this.fileChanged(ev);
          }}
        />
        <p>{this.state.error}</p>
        <p>
          Download a sample CSV template to see an example of the required format.
        </p>

        <Button
          variant="contained"
          color="primary"
          type="submit"
          style={{marginTop: 20, float: "right"}}
          disabled={!this.state.csvData || isSubmitting}
        >
          <ImportIcon />
        </Button>
      </form>
    );
  }
}

export default TeamImportForm;
