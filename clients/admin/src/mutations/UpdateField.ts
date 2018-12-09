import client from "../modules/apollo";
import mutationPromise from "../helpers/mutationPromise"
import { query } from "../views/Fields";
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

function commit(variables: UpdateFieldMutationVariables) {
  return mutationPromise((resolve, reject) => {
    client.mutate({
      mutation,
      variables,
      update: (store, { data: { updateField } }) => {
        const data = store.readQuery({ query }) as any;
        const fieldIdx = data.fields.findIndex((f: any) => {
          return f.id === variables.input.id;
        });

        Object.assign(data.fields[fieldIdx], updateField.field);

        store.writeQuery({ query, data });
      }
    }).then(({ data: { updateField } }) => {
      resolve(updateField as MutationResult);
    }).catch((error) => {
      reject(error);
    });
  });
}

export default { commit };
