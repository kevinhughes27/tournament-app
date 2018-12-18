import gql from 'graphql-tag';

export const query = gql`
  query DivisionSeedQuery($divisionId: ID!) {
    division(id: $divisionId) {
      id
      name
      numTeams
      teams {
        id
        name
        seed
      }
    }
    teams {
      id
      name
      seed
    }
  }
`;
