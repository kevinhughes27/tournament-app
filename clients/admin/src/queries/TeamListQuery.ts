import gql from "graphql-tag";

export const query = gql`
  query TeamListQuery {
    teams {
      id
      name
      email
      division {
        id
        name
      }
      seed
    },
    divisions {
      id
      name
    }
  }
`;
