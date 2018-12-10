import * as React from "react";
import ErrorBanner, { hideErrors } from "./ErrorBanner";
import runMutation from "../helpers/runMutation";
import {
  Formik,
  FormikProps,
  FormikValues,
  FormikErrors,
  FormikActions
} from "formik";

class Form<T> extends React.Component<T> {
  initialValues: any = () => {
    throw new Error("You have to implement initialValues");
  }

  validate = ({}: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};
    return errors;
  }

  mutation: any = () => {
    throw new Error("You have to implement mutation");
  }

  mutationInput: any = ({}: FormikValues) => {
    throw new Error("You have to implement mutationInput");
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

  renderForm: any = ({}: FormikProps<FormikValues>) => {
    throw new Error("You have to implement renderForm");
  }

  private onSubmit = (values: FormikValues, actions: FormikActions<FormikValues>) => {
    hideErrors();

    runMutation(
      this.mutation(),
      this.mutationInput(values),
      {
        complete: () => {
          actions.setSubmitting(false);
          actions.resetForm();
        },
        failed: (result: MutationResult) => {
          actions.setSubmitting(false);
          setFieldErrors(actions, result.userErrors);
        }
      }
    );
  }
}

const setFieldErrors = (
  actions: FormikActions<FormikValues>,
  userErrors: ReadonlyArray<UserError> | null
) => {
  const errors = userErrors || [];

  errors.forEach((error) => {
    actions.setFieldError(error.field, error.message);
  });
};

export default Form;
