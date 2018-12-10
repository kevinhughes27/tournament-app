type MutationResolve = (result: MutationResult) => void;
type MutationReject = (error: Error | undefined) => void;

function mutationPromise(
  implementation: (resolve: MutationResolve, reject: MutationReject) => void
) {
  return new Promise((resolve: MutationResolve, reject: MutationReject) => {
    implementation(resolve, reject);
  });
}

export default mutationPromise;
