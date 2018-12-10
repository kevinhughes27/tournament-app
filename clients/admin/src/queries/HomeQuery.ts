import gql from 'graphql-tag';

export const query = gql`
  query HomeQuery {
    fields {
      id
    }
    teams {
      id
    }
    divisions {
      id
      numTeams
      isSeeded
    }
    games {
      id
      scheduled
      endTime
      scoreConfirmed
    }
    scoreDisputes {
      id
    }
  }
`;
