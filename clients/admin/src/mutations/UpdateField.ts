import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise";
import mutationUpdater from "../helpers/mutationUpdater";
import { query } from "../queries/FieldsEditorQuery";
import gql from "graphql-tag";

const mutation = gql`
  mutation UpdateFieldMutation($input: UpdateFieldInput!) {
    updateField(input:$input) {
      field {
        id
        name
        lat
        long
        geoJson
      }
      success
      message
      userErrors {
        field
        message
      }
    }
  }
`;

const update = mutationUpdater<UpdateFieldMutation>((store, payload) => {
  if (payload.updateField && payload.updateField.success) {
    const data = store.readQuery({ query }) as any;
    const updatedField = payload.updateField.field;

    const fieldIdx = data.fields.findIndex((f: any) => {
      return f.id === updatedField.id;
    });

    Object.assign(data.fields[fieldIdx], updatedField);

    store.writeQuery({ query, data });
  }
});

function commit(variables: UpdateFieldMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      update
    }).then(({ data: { updateField } }) => {
      resolve(updateField as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
