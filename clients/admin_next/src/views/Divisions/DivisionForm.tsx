import * as React from "react";
import { FormikValues, FormikProps, FormikErrors } from "formik";
import { isEmpty } from "lodash";

import TextField from "@material-ui/core/TextField";
import BracketPicker from "./BracketPickerContainer";
import SubmitButton from "../../components/SubmitButton";

import Form from "../../components/Form";
import CreateDivisionMutation from "../../mutations/CreateDivision";

interface Props {
  input: CreateDivisionMutationVariables["input"];
}

class DivisionForm extends Form<Props> {
  initialValues = () => {
    return this.props.input;
  }

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (!values.name) {
      errors.name = "Required";
    }

    if (values.numTeams && values.numTeams <= 0) {
      errors.numTeams = "Must be greater than 0";
    }

    if (values.numDays && values.numDays <= 0) {
      errors.numDays = "Must be greater than 0";
    }

    return errors;
  }

  submit = (values: FormikValues) => {
    return CreateDivisionMutation.commit({input: {...values}});
  }

  renderForm = (formProps: FormikProps<FormikValues>) => {
    const {
      values,
      dirty,
      errors,
      handleChange,
      handleSubmit,
      isSubmitting
    } = formProps;

    return (
      <form onSubmit={handleSubmit}>
        <TextField
          name="name"
          label="Name"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.name}
          onChange={handleChange}
          helperText={formProps.errors.name}
        />
        <TextField
          name="numTeams"
          label="Number of Teams"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.numTeams}
          onChange={handleChange}
          helperText={formProps.errors.numTeams}
        />
        <TextField
          name="numDays"
          label="Number of Days"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.numDays}
          onChange={handleChange}
          helperText={formProps.errors.numDays}
        />
        <BracketPicker
          numTeams={values.numTeams}
          numDays={values.numDays}
          bracketType={values.bracketType}
          onChange={handleChange}
        />
        <SubmitButton
          disabled={!dirty || !isEmpty(errors)}
          submitting={isSubmitting}
          text="Save"
        />
      </form>
    );
  }
}

export default DivisionForm;
