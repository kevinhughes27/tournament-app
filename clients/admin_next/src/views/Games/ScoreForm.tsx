import * as React from "react";
import { FormikValues, FormikProps, FormikErrors } from "formik";

import TextField from "@material-ui/core/TextField";
import SubmitButton from "../../components/SubmitButton";

import Form from "../../components/Form";
import UpdateScoreMutation from "../../mutations/UpdateScore";

interface Props {
  input: UpdateScoreMutationVariables["input"];
}

class ScoreForm extends Form<Props> {
  initialValues = () => {
    const { input } = this.props;

    return {
      homeScore: input.homeScore || "",
      awayScore: input.awayScore || ""
    };
  }

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (values.homeScore && values.homeScore <= 0) {
      errors.homeScore = "Invalid score";
    }

    if (values.awayScore && values.awayScore <= 0) {
      errors.awayScore = "Invalid score";
    }

    return errors;
  }

  submit = (values: FormikValues) => {
    return UpdateScoreMutation.commit({
      input: {
        gameId: this.props.input.gameId,
        homeScore: values.homeScore,
        awayScore: values.awayScore
      }
    });
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

    const hasErrors = Object.keys(errors).length !== 0;

    return (
      <form onSubmit={handleSubmit}>
        <TextField
          name="homeScore"
          label="Home Score"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.homeScore}
          onChange={handleChange}
          helperText={formProps.errors.homeScore && formProps.errors.homeScore}
        />
        <TextField
          name="awayScore"
          label="Away Score"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.awayScore}
          onChange={handleChange}
          helperText={formProps.errors.awayScore && formProps.errors.awayScore}
        />
        <SubmitButton
          disabled={!dirty || hasErrors}
          submitting={isSubmitting}
        />
      </form>
    );
  }
}

export default ScoreForm;
