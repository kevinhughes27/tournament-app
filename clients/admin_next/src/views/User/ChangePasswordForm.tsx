import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { FormikValues, FormikProps, FormikErrors } from "formik";
import { isEmpty } from "lodash";

import TextField from "@material-ui/core/TextField";
import FormButtons from "../../components/FormButtons";

import Form from "../../components/Form";
import ChangeUserPasswordMutation from "../../mutations/ChangeUserPassword";

interface Props extends RouteComponentProps<any> {
  input: ChangeUserPasswordMutationVariables["input"];

}

class ChangePasswordForm extends Form<Props> {

  initialValues = () => {
    const { input } = this.props;
    return {
      password: input.password || "",
      password_confirmation: "",
    };
  }

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (!values.password) {
      errors.password = "Required";
    }

    if (values.password.length < 6) {
      errors.password = "Minimum 6 character Required";
    }

    if (values.password !== values.password_confirmation ) {
      errors.password = "Required";
    }

    return errors;
  }

  mutation = () => {
    return ChangeUserPasswordMutation;
  }

  mutationInput = (values: FormikValues) => {
    return {
      input: {
        id: this.props.input.id,
        password: values.password,
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
          name="password"
          label="Password"
          type="password"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.password}
          onChange={handleChange}
        />
        <TextField
          name="password_confirmation"
          label="Confirm Password"
          type="password"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.password_confirmation}
          onChange={handleChange}
        />
        <FormButtons
          formDirty={dirty}
          formValid={isEmpty(errors)}
          submitting={isSubmitting}
        />
      </form>
    );
  }
}

export default withRouter(ChangePasswordForm);
