import * as React from "react";
import { FormikValues, FormikProps, FormikErrors } from "formik";

import TextField from "@material-ui/core/TextField";
import SubmitButton from "../../components/SubmitButton";

import Form from "../../components/Form";
import UpdateScoreMutation from "../../mutations/UpdateScore";

interface Props {
  game: Game;
}

class ScoreForm extends Form<Props> {
  initialValues = () => {
    const { game } = this.props;

    return {
      homeScore: game.homeScore || "",
      awayScore: game.awayScore || ""
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
    return UpdateScoreMutation.commit(values, this.props.game);
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
          text="Save"
        />
      </form>
    );
  }
}

export default ScoreForm;
