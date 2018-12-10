import gql from 'graphql-tag';

export const query = gql`
  query BracketPickerQuery($numTeams: Int!, $numDays: Int!) {
    brackets(numTeams: $numTeams, numDays: $numDays) {
      handle
      name
      description
      games
      tree
    }
  }
`;
