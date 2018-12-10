import gql from 'graphql-tag';

export const query = gql`
  query DivisionSeedQuery($divisionId: ID!) {
    division(id: $divisionId) {
      id
      name
      teams {
        id
        name
        seed
      }
    }
  }
`;
