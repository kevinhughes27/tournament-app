import * as React from 'react';
import csv from 'csv';
import { Formik, FormikValues, FormikProps, FormikActions } from 'formik';
import { isEqual } from 'lodash';
import fileDownload from 'react-file-download';
import FileInput from '../FileInput';
import FormButtons from '../FormButtons';

interface Props {
  csvHeader: string[];
  object: string;
  icon: JSX.Element;
  startImport: (data: string[][]) => void;
  closeModal: () => void;
}

interface State {
  data: string[][];
  error: string;
}

const defaultState = {
  data: [],
  error: ''
};

class ImportForm extends React.Component<Props, State> {
  state = defaultState;

  initialValues = () => {
    return {
      csvFile: ''
    };
  };

  fileChanged = async (ev: React.ChangeEvent<HTMLInputElement>) => {
    this.setState(defaultState);

    const files = ev.target.files;

    if (files && files.length === 1) {
      const file = files[0];
      const csvData = await this.uploadCSV(file);
      this.validateCSV(csvData);
    }
  };

  uploadCSV = (file: File) => {
    const reader = new FileReader();

    return new Promise<string>(resolve => {
      reader.onload = () => {
        resolve(reader.result as string);
      };

      reader.readAsText(file);
    });
  };

  validateCSV = (csvData: string) => {
    csv.parse(csvData, (err: string, data: string[][]) => {
      if (err) {
        this.setState({ error: 'Invalid CSV file' });
        return;
      }

      const header = data[0];
      const rows = data.slice(1);

      if (!isEqual(header, this.props.csvHeader)) {
        this.setState({ error: 'Invalid CSV Columns' });
        return;
      }

      this.setState({ data: rows });
    });
  };

  onSubmit = (_values: FormikValues, actions: FormikActions<FormikValues>) => {
    actions.resetForm();
    this.props.startImport(this.state.data);
  };

  downloadSampleCSV = () => {
    fileDownload(this.props.csvHeader, `${this.props.object}.csv`);
  };

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
    const { values, handleChange, handleSubmit, isSubmitting } = formProps;

    return (
      <form onSubmit={handleSubmit}>
        <FileInput
          name="csvFile"
          value={values.csvFile}
          accept=".csv"
          buttonText="CSV File"
          onChange={ev => {
            handleChange(ev);
            this.fileChanged(ev);
          }}
        />
        <p>{this.state.error}</p>

        <p>
          <a href="/sample_csv" onClick={this.downloadSampleCSV}>
            Download
          </a>{' '}
          a sample CSV template to see an example of the required format.
        </p>

        <FormButtons
          inline
          submitIcon={this.props.icon}
          formValid={!!this.state.data && !this.state.error}
          submitting={isSubmitting}
          cancel={this.props.closeModal}
        />
      </form>
    );
  };
}

export default ImportForm;
