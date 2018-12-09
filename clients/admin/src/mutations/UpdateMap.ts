import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise"
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
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables
    }).then(({ data: { updateMap } }) => {
      resolve(updateMap as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
