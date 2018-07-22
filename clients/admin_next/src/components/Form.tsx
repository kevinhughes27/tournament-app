import * as React from "react";
import ErrorBanner, { hideErrors } from "./ErrorBanner";
import {
  Formik,
  FormikProps,
  FormikValues,
  FormikErrors,
  FormikActions
} from "formik";

class Form<T> extends React.Component<T> {
  initialValues: any = () => {
    throw new Error('You have to implement initialValues');
  }

  validate = ({}: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};
    return errors;
  };

  submit: any = ({}: FormikValues, {}: FormikActions<FormikValues>) => {
    throw new Error('You have to implement submit');
  };

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
    throw new Error('You have to implement renderForm');
  };

  private onSubmit = (values: FormikValues, actions: FormikActions<FormikValues>) => {
    hideErrors();
    this.submit(values, actions);
  }
}

export default Form;
