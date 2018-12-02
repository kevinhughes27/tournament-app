import * as React from "react";
import { FormikValues, FormikProps, FormikErrors } from "formik";
import { isEmpty } from "lodash";
import TextField from "@material-ui/core/TextField";
import Form from "../../components/Form";
import FormButtons from "../../components/FormButtons";
import ChangeUserPasswordMutation from "../../mutations/ChangeUserPassword";

class PasswordForm extends Form<{}> {
  initialValues = () => {
    return {
      password: "",
      passwordConfirmation: ""
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

    if (values.password !== values.passwordConfirmation) {
      errors.passwordConfirmation = "Passwords don't match";
    }

    return errors;
  }

  mutation = () => {
    return ChangeUserPasswordMutation;
  }

  mutationInput = (values: FormikValues) => {
    return {
      input: {
        password: values.password,
        passwordConfirmation: values.passwordConfirmation,
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
          label="Change Password"
          type="password"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.password}
          onChange={handleChange}
          helperText={errors.password}
        />
        <TextField
          name="passwordConfirmation"
          label="Confirm Password"
          type="password"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.passwordConfirmation}
          onChange={handleChange}
          helperText={errors.passwordConfirmation}
        />
        <FormButtons
          inline={true}
          formDirty={dirty}
          formValid={isEmpty(errors)}
          submitting={isSubmitting}
        />
      </form>
    );
  }
}

export default PasswordForm;
