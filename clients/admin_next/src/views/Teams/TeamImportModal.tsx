import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions } from "formik";
import { Modal as styles } from "../../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { last } from "lodash";
import Button from "@material-ui/core/Button";
import Modal from "@material-ui/core/Modal";
import Radio from "@material-ui/core/Radio";
import RadioGroup from "@material-ui/core/RadioGroup";
import FormControlLabel from "@material-ui/core/FormControlLabel";
import Typography from "@material-ui/core/Typography";
import IconButton from "@material-ui/core/IconButton";
import CloseIcon from "@material-ui/icons/Close";
import ImportIcon from "@material-ui/icons/GroupAdd";

interface Props extends WithStyles<typeof styles> {
  open: boolean;
  handleClose: () => void;
}

interface State {
  csvData: string;
}

class TeamImportModal extends React.Component<Props, State> {
  state = {
    csvData: ""
  };

  initialValues = () => {
    return {
      csvFile: "",
      override: "ignore"
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

  onSubmit = (values: FormikValues, actions: FormikActions<FormikValues>) => {
    return null;
  }

  render() {
    const { classes } = this.props;

    return (
      <Modal open={this.props.open} onClose={this.props.handleClose}>
        <div className={classes.paper}>
          {this.renderTitle()}
          <Formik
            initialValues={this.initialValues()}
            onSubmit={this.onSubmit}
            render={this.renderForm}
          />
        </div>
      </Modal>
    );
  }

  renderTitle = () => {
    const style = {
      display: "flex",
      justifyContent: "space-between",
      alignItems: "center"
    };

    return (
      <div style={style}>
        <Typography variant="title">
          Import Teams
        </Typography>
        <IconButton onClick={this.props.handleClose}>
          <CloseIcon />
        </IconButton>
      </div>
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

        <p>
          When importing the teams found in the CSV file we'll match against existing teams by name.
          When we find a match would you like us to:
        </p>

        <RadioGroup
          name="override"
          value={values.override}
          onChange={handleChange}
        >
          <FormControlLabel
            value="ignore"
            control={<Radio />}
            label="Ignore and go on to the next team"
          />
          <FormControlLabel
            value="override"
            control={<Radio />}
            label="Update the team to match the CSV file"
          />
        </RadioGroup>

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

export default withStyles(styles)(TeamImportModal);
