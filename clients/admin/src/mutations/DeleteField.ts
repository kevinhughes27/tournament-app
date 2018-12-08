import client from "../modules/apollo";
import { query } from "../views/Fields";
import gql from "graphql-tag";

const mutation = gql`
  mutation DeleteFieldMutation($input: DeleteFieldInput!) {
    deleteField(input:$input) {
      success
      confirm
      message
      userErrors {
        field
        message
      }
    }
  }
`;

function commit(variables: DeleteFieldMutationVariables) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      client.mutate({
        mutation,
        variables,
        update: (store) => {
          const data = store.readQuery({ query }) as any;
          data.fields = data.fields.filter((f: any) => f.id !== variables.input.id);
          store.writeQuery({ query, data });
        }
      }).then(({ data: { deleteField } }) => {
        resolve(deleteField as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
