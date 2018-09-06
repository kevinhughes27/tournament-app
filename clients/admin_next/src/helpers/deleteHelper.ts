import { showNotice } from "../components/Notice";
import { showErrors } from "../components/ErrorBanner";

const Delete = (mutation: any, input: any, done: () => void) => {
  return () => {
    mutation.commit(input).then((result: MutationResult) => {
      deleteComplete(result, done);
    }, (error: Error | undefined) => {
      deleteError(error);
    });
  };
};

const deleteComplete = (result: MutationResult, done: () => void) => {
  if (result.success) {
    deleteSuccess(result, done);
  } else {
    deleteFailed(result);
  }
};

const deleteSuccess = (result: MutationResult, done: () => void) => {
  showNotice(result.message);
  done();
};

const deleteFailed = (result: MutationResult) => {
  showErrors(result.message);
};

const deleteError = (error: Error | undefined) => {
  showErrors(error && error.message || "Something went wrong.");
};

export default Delete;
