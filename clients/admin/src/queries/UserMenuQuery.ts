import gql from 'graphql-tag';

export const query = gql`
  query UserMenuQuery {
    viewer {
      id
      name
      email
    }
  }
`;
