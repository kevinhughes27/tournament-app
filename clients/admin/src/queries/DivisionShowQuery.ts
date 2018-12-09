import gql from "graphql-tag";

export const query = gql`
  query DivisionShowQuery($divisionId: ID!) {
    division(id: $divisionId) {
      id
      name
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
        description
      }
    }
  }
`;
