import client from "../modules/apollo";
import gql from "graphql-tag";

const mutation = gql`
  mutation UpdateMapMutation($input: UpdateMapInput!) {
    updateMap(input:$input) {
      success
      message
    }
  }
`;

function commit(variables: UpdateMapMutationVariables) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      client.mutate({
        mutation,
        variables
      }).then(({ data: { updateMap } }) => {
        resolve(updateMap as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
