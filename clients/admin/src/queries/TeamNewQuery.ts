import gql from "graphql-tag";

export const query = gql`
  query TeamNewQuery {
    divisions {
      id
      name
    }
  }
`;
