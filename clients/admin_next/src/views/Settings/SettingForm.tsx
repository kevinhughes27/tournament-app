import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { FormikValues, FormikProps } from "formik";
import { isEmpty } from "lodash";

import TextField from "@material-ui/core/TextField";
import FormButtons from "../../components/FormButtons";
import Form from "../../components/Form";
import UpdateSettingsMutation from "../../mutations/UpdateSettings";

interface Props extends RouteComponentProps<any> {
  input: UpdateSettingsMutationVariables["input"];
}

class SettingForm extends Form<Props> {

  initialValues = () => {
    const { input } = this.props;
    return {
      name: input.name || "",
      handle: input.handle || "",
      timezone: input.timezone || ""
    };
  }

  mutation = () => {
    return UpdateSettingsMutation;
  }

  mutationInput = (values: FormikValues) => {
    return {input: values};
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
          type="name"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.name}
          onChange={handleChange}
        />
        <TextField
          name="handle"
          label="Handle"
          type="name"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.handle}
          onChange={handleChange}
        />
        <TextField
          name="timezone"
          label="TimeZone"
          type="name"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.timezone}
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

export default withRouter(SettingForm);
