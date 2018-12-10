import { showNotice } from "../components/Notice";
import { showConfirm } from "../components/Confirm";
import { showErrors } from "../components/ErrorBanner";
import { merge } from "lodash";

type Mutation = any;

interface MutationInput {
  input: any;
}

type MutationCallback = (result: MutationResult) => void;

interface Options {
  complete?: MutationCallback;
  failed?: MutationCallback;
}

const runMutation = async (
  mutation: Mutation,
  input: MutationInput,
  options: Options = {}
) => {
  try {
    const result = await mutation.commit(input);

    if (result.success) {
      mutationSuccess(result, options.complete);

    } else if (result.confirm) {
      showConfirm(
        result.message,
        confirmMutation(mutation, input, options),
        () => { if (options.failed) { options.failed(result); } }
      );

    } else {
      mutationFailed(result, options.failed);
    }

  } catch (error) {
    mutationError(error, options.failed);
  }
};

const confirmMutation = (
  mutation: Mutation,
  input: MutationInput,
  options: Options = {}
) => {
  return () => {
    const confirmedInput = merge({}, {...input}, {input: {confirm: true}});
    runMutation(mutation, confirmedInput, options);
  };
};

const mutationSuccess = (result: MutationResult, complete?: MutationCallback) => {
  showNotice(result.message);
  if (complete) { complete(result); }
};

const mutationFailed = (result: MutationResult, failed?: MutationCallback) => {
  /*
   * Try and show page errors if possible
   * otherwise fallback to notice.
   */
  try {
    showErrors(result.message);
  } catch (error) {
    showNotice(result.message);
  }

  if (failed) { failed(result); }
};

const mutationError = (error: Error, failed?: MutationCallback) => {
  const message = error.message || "Something went wrong.";
  const result = {success: false, message, userErrors: []};

    /*
   * Try and show page errors if possible
   * otherwise fallback to notice.
   */
  try {
    showErrors(message);
  } catch (error) {
    showNotice(message);
  }

  if (failed) { failed(result); }
};

export default runMutation;
