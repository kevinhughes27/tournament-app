import gql from "graphql-tag";

export const query = gql`
  query DivisionEditQuery($divisionId: ID!) {
    division(id: $divisionId) {
      id
      name
      numTeams
      numDays
      games {
        pool
        homePrereq
        homeName
        awayPrereq
        awayName
      }
      bracketTree
      bracket {
        name
        handle
        description
      }
    }
  }
`;
