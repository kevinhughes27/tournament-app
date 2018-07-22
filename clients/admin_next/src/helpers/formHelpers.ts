import { FormikValues, FormikActions } from "formik";
import { FormAPI } from "components/Form";
import { showNotice } from "../components/Notice";

const onComplete = (
  result: MutationResult,
  props: FormAPI,
  actions: FormikActions<FormikValues>
) => {
  actions.setSubmitting(false);

  if (result.success) {
    handleSuccess(result, props, actions);
  } else {
    handleFailure(result, props, actions);
  }
};

const onError = (error: Error | undefined, props: FormAPI) => {
  props.showError(error && error.message || "Something went wrong.");
};

const handleSuccess = (
  result: MutationResult,
  props: FormAPI,
  actions: FormikActions<FormikValues>
) => {
  actions.resetForm();
  showNotice(result.message);
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
  onComplete,
  onError
};
