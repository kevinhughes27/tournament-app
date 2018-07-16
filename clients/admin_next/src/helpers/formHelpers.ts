import { FormikValues, FormikActions } from "formik";
import { FormAPI } from "components/Form";

const onComplete = (
  result: MutationResult,
  message: string,
  props: FormAPI,
  actions: FormikActions<FormikValues>
) => {
  actions.setSubmitting(false);

  if (result.success) {
    handleSuccess(message, props, actions);
  } else {
    handleFailure(result, props, actions);
  }
};

const handleSuccess = (
  message: string,
  props: FormAPI,
  actions: FormikActions<FormikValues>
) => {
  actions.resetForm();
  props.showMessage(message);
};

const handleFailure = (
  result: MutationResult,
  props: FormAPI,
  actions: FormikActions<FormikValues>
) => {
  if (result.userErrors) {
    setFieldErrors(result.userErrors, actions);
  } else if (result.message) {
    props.showError(result.message);
  } else {
    props.showError("Something went wrong.");
  }
};

const setFieldErrors = (
  errors: UserError[],
  actions: FormikActions<FormikValues>
) => {
  errors.forEach((error) => {
    actions.setFieldError(error.field, error.message);
  });
};

export {
  onComplete
};
