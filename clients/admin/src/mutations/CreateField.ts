import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise";
import mutationUpdater from "../helpers/mutationUpdater";
import { query } from "../queries/FieldsEditorQuery";
import gql from "graphql-tag";

const mutation = gql`
  mutation CreateFieldMutation($input: CreateFieldInput!) {
    createField(input:$input) {
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

const update = mutationUpdater<CreateFieldMutation>((store, payload) => {
  if (payload.createField && payload.createField.success) {
    const data = store.readQuery({ query }) as any;
    const newField = payload.createField.field;
    data.fields.push(newField);
    store.writeQuery({ query, data });
  }
});

function commit(variables: CreateFieldMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      update
    }).then(({ data: { createField } }) => {
      resolve(createField as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
