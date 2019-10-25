import gql from 'graphql-tag';

export const query = gql`
  query UserQuery {
    viewer {
      id
      name
      email
    }
  }
`;
