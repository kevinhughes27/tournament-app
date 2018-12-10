import gql from 'graphql-tag';

export const query = gql`
  query DivisionListQuery {
    divisions {
      id
      name
      bracket {
        handle
      }
      teamsCount
      numTeams
      isSeeded
    }
  }
`;
