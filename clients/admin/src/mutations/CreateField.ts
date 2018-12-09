import client from "../modules/apollo";
import { query } from "../views/Fields";
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

function commit(variables: CreateFieldMutationVariables) {
  return new Promise(
    (
      resolve: (result: MutationResult) => void,
      reject: (error: Error | undefined) => void
    ) => {
      client.mutate({
        mutation,
        variables,
        update: (store, { data: { createField } }) => {
          const data = store.readQuery({ query }) as any;
          const newField = createField.field;
          if (newField) {
            data.fields.push(newField);
            store.writeQuery({ query, data });
          }
        }
      }).then(({ data: { createField } }) => {
        resolve(createField as MutationResult);
      }).catch((error) => {
        reject(error);
      });
    }
  );
}

export default { commit };
