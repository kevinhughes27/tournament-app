import gql from "graphql-tag";

export const query = gql`
  query GameListQuery {
    games {
      id
      division {
        id
        name
      }
      pool
      startTime
      endTime
      hasTeams
      homeName
      awayName
      homeScore
      awayScore
      scoreReports {
        id
        id
        submittedBy
        submitterFingerprint
        homeScore
        awayScore
        rulesKnowledge
        fouls
        fairness
        attitude
        communication
        comments
      }
      scoreConfirmed
      scoreDisputed
    }
  }
`;
