import * as React from "react";
import { Formik, FormikValues, FormikProps } from "formik";
import { Modal as styles } from "../../../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { last } from "lodash";
import Button from "@material-ui/core/Button";
import ImportIcon from "@material-ui/icons/GroupAdd";

interface Props extends WithStyles<typeof styles> {
  importTeams: (csvData: string) => void;
}

interface State {
  csvData: string;
}

class TeamImportForm extends React.Component<Props, State> {
  state = {
    csvData: ""
  };

  initialValues = () => {
    return {
      csvFile: ""
    };
  }

  fileChanged = (ev: React.ChangeEvent<HTMLInputElement>) => {
    this.setState({csvData: ""});

    const files = ev.target.files;

    if (files && files.length === 1) {
      const file = files[0];
      const reader = new FileReader();

      reader.readAsText(file);
      reader.onload = () => {
        const csvData = reader.result;
        this.setState({csvData});
      };
    }
  }

  onSubmit = () => {
    this.props.importTeams(this.state.csvData);
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

    const prettyFileName = last(values.csvFile.split("\\"));

    return (
      <form onSubmit={handleSubmit}>
        <input
          id="upload-button"
          name="csvFile"
          accept=".csv"
          style={{display: "none"}}
          type="file"
          value={values.csvFile}
          onChange={(ev) => {
            handleChange(ev);
            this.fileChanged(ev);
          }}
        />
        <label htmlFor="upload-button">
          <Button variant="contained" component="span">
            CSV File
          </Button>
        </label>
        <span style={{paddingLeft: 20}}>
          {prettyFileName}
        </span>

        <p>
          Download a sample CSV template to see an example of the required format.
        </p>

        <Button
          variant="contained"
          color="primary"
          type="submit"
          className={this.props.classes.button}
          disabled={!this.state.csvData || isSubmitting}
        >
          <ImportIcon />
        </Button>
      </form>
    );
  }
}

export default withStyles(styles)(TeamImportForm);
