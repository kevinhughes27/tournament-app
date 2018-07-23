import { FormikValues, FormikActions } from "formik";
import { showNotice } from "../components/Notice";
import { showErrors } from "../components/ErrorBanner";

const onComplete = (
  result: MutationResult,
  actions: FormikActions<FormikValues>
) => {
  actions.setSubmitting(false);

  if (result.success) {
    handleSuccess(result, actions);
  } else {
    handleFailure(result, actions);
  }
};

const handleSuccess = (
  result: MutationResult,
  actions: FormikActions<FormikValues>
) => {
  actions.resetForm();
  showNotice(result.message);
};

const handleFailure = (
  result: MutationResult,
  actions: FormikActions<FormikValues>
) => {
  if (result.userErrors) {
    setFieldErrors(result.userErrors, actions);
  } else if (result.message) {
    showErrors(result.message);
  } else {
    showErrors("Something went wrong.");
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

const onError = (error: Error | undefined) => {
  showErrors(error && error.message || "Something went wrong.");
};

export {
  onComplete,
  onError
};
