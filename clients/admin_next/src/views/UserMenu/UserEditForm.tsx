import * as React from "react";
import * as EmailValidator from "email-validator";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { FormikValues, FormikProps, FormikErrors } from "formik";
import { isEmpty } from "lodash";

import TextField from "@material-ui/core/TextField";
import FormButtons from "../../components/FormButtons";

import Form from "../../components/Form";
import UpdateUserMutation from "../../mutations/UpdateUser";

interface Props extends RouteComponentProps<any> {
  input: UpdateUserMutationVariables["input"];

}

class UserEditForm extends Form<Props> {

  initialValues = () => {
    const { input } = this.props;
    return {
      email: input.email || "",
      name: input.name || ""
    };
  }

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (!values.email) {
      errors.email = "Required";
    }

    if (values.email && !EmailValidator.validate(values.email)) {
      errors.email = "Invalid email address";
    }

    return errors;
  }

  mutation = () => {
    return UpdateUserMutation;
  }

  mutationInput = (values: FormikValues) => {
    return {
      input: {
        id: this.props.input.viewerId,
        email: values.email,
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
          name="name"
          label="Name"
          type="text"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.name}
          onChange={handleChange}
        />

        <TextField
          name="email"
          label="Email"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.email}
          onChange={handleChange}
          helperText={errors.email}
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

export default withRouter(UserEditForm);
