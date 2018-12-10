import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise"
import mutationUpdater from "../helpers/mutationUpdater";
import { query } from "../queries/FieldsEditorQuery";
import gql from "graphql-tag";

const mutation = gql`
  mutation DeleteFieldMutation($input: DeleteFieldInput!) {
    deleteField(input:$input) {
      field {
        id
      }
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

const update = mutationUpdater<DeleteFieldMutation>((store, payload) => {
  if (payload.deleteField && payload.deleteField.success) {
    const data = store.readQuery({ query }) as any;
    const deletedField = payload.deleteField.field;

    data.fields = data.fields.filter((f: any) => f.id !== deletedField.id);
    store.writeQuery({ query, data });
  }
});

function commit(variables: DeleteFieldMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      update
    }).then(({ data: { deleteField } }) => {
      resolve(deleteField as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
