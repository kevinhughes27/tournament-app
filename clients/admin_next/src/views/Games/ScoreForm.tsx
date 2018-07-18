import * as React from "react";
import { Formik, FormikValues, FormikProps, FormikActions, FormikErrors } from "formik";

import TextField from "@material-ui/core/TextField";
import SubmitButton from "../../components/SubmitButton";

import { Form, FormAPI } from "../../components/Form";
import { onComplete, onError } from "../../helpers/formHelpers";

import environment from "../../relay";
import UpdateScoreMutation from "../../mutations/UpdateScore";

interface Props {
  game: Game;
}

class ScoreForm extends React.Component<Props & FormAPI> {
  initialValues = () => {
    const { game } = this.props;

    return {
      homeScore: game.homeScore || "",
      awayScore: game.awayScore || ""
    };
  }

  render() {
    return (
      <Formik
        initialValues={this.initialValues()}
        validate={this.validate}
        onSubmit={this.onSubmit}
        render={this.renderForm}
      />
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
    this.props.reset();

    UpdateScoreMutation.commit(
      environment,
      values,
      this.props.game,
      (result) => onComplete(result, this.props, actions),
      (error) => onError(error, this.props)
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

export default Form(ScoreForm);
