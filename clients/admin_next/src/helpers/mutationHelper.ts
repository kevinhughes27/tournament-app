import { showNotice } from "../components/Notice";
import { showErrors } from "../components/ErrorBanner";

const runMutation = (
  mutation: any,
  input: any,
  done: () => void
) => {
  return () => {
    mutation.commit(input).then((result: MutationResult) => {
      mutationComplete(result, done);
    }, (error: Error | undefined) => {
      mutationError(error);
    });
  };
};

const mutationComplete = (result: MutationResult, done: () => void) => {
  if (result.success) {
    mutationSuccess(result, done);
  } else {
    mutationFailed(result);
  }
};

const mutationSuccess = (result: MutationResult, done: () => void) => {
  showNotice(result.message);
  done();
};

const mutationFailed = (result: MutationResult) => {
  showErrors(result.message);
};

const mutationError = (error: Error | undefined) => {
  showErrors(error && error.message || "Something went wrong.");
};

export default runMutation;
