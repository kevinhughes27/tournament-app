import gql from 'graphql-tag';

export default {
  document: gql`
    subscription GameListSubscription {
      gameUpdated {
        id
        hasTeams
        homeName
        awayName
        homeScore
        awayScore
        scoreReports {
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
  `,
  updateQuery: (prev: any, { subscriptionData }: any) => {
    if (!subscriptionData.data) return prev;

    const updatedGame = subscriptionData.data.gameUpdated;
    const gameIdx = prev.games.findIndex((g: GameListQuery_games) => {
      return g.id === updatedGame.id;
    });

    Object.assign(prev.games[gameIdx], updatedGame);

    return {
      games: prev.games
    };
  }
};
