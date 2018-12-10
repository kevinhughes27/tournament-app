import gql from 'graphql-tag';

export const query = gql`
  query FieldsEditorQuery {
    map {
      lat
      long
      zoom
    }
    fields {
      id
      name
      lat
      long
      geoJson
    }
  }
`;
