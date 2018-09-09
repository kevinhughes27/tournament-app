import * as React from "react";
import { FormikValues, FormikProps, FormikErrors } from "formik";
import { isEmpty } from "lodash";

import TextField from "@material-ui/core/TextField";
import FormButtons from "../../components/FormButtons";

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

  mutation = () => {
    return UpdateScoreMutation;
  }

  mutationInput = (values: FormikValues) => {
    return {
      input: {
        gameId: this.props.input.gameId,
        homeScore: values.homeScore,
        awayScore: values.awayScore
      }
    };
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
          name="homeScore"
          label="Home Score"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.homeScore}
          onChange={handleChange}
          helperText={errors.homeScore}
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
          helperText={errors.awayScore}
        />
        <FormButtons
          formDirty={dirty}
          formValid={isEmpty(errors)}
          submitting={isSubmitting}
          cancelLink={"/games"}
        />
      </form>
    );
  }
}

export default ScoreForm;
