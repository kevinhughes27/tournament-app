import gql from 'graphql-tag';

export const query = gql`
  query ScheduleEditorQuery {
    fields {
      id
      name
    }
    games {
      id
      homePrereq
      awayPrereq
      homePoolSeed
      awayPoolSeed
      pool
      bracketUid
      round
      startTime
      endTime
      field {
        id
        name
      }
      division {
        id
        name
      }
    }
  }
`;
