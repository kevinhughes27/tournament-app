import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions, FormikErrors } from "formik";

import TextField from "@material-ui/core/TextField";
import SubmitButton from "../../components/SubmitButton";

import environment from "../../relay";
import UpdateScoreMutation from "../../mutations/UpdateScore";
import { onComplete, onError } from "../../helpers/formHelpers";
import ErrorBanner, { hideErrors } from "../../components/ErrorBanner";

interface Props {
  game: Game;
}

class ScoreForm extends React.Component<Props> {
  initialValues = () => {
    const { game } = this.props;

    return {
      homeScore: game.homeScore || "",
      awayScore: game.awayScore || ""
    };
  }

  render() {
    return (
      <div style={{padding: 20}}>
        <ErrorBanner />
        <Formik
          initialValues={this.initialValues()}
          validate={this.validate}
          onSubmit={this.onSubmit}
          render={this.renderForm}
        />
      </div>
    );
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

  onSubmit = (values: FormikValues, actions: FormikActions<FormikValues>) => {
    hideErrors();

    UpdateScoreMutation.commit(
      environment,
      values,
      this.props.game,
      (result) => onComplete(result, actions),
      (error) => onError(error)
    );
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
