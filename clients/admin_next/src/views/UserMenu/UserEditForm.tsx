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

class UserEditForm extends Form<Props> {
  initialValues = () => {
    const { input } = this.props;

    
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

export default UserEditForm;
