GameUpdateScoreMutation = GraphQL::Relay::Mutation.define do
  name "GameUpdateScore"

  input_field :game_id, types.ID
  input_field :home_score, types.Int
  input_field :away_score, types.Int
  input_field :force, types.Boolean
  input_field :resolve, types.Boolean

  return_field :success, !types.Boolean

  resolve(Auth.protect -> (obj, inputs, ctx) {
    game = ctx[:tournament].games.find(inputs[:game_id])

    op = GameUpdateScore.new(
      game: game,
      home_score: inputs[:home_score],
      away_score: inputs[:away_score],
      user: ctx[:current_user],
      force: inputs[:force],
      resolve: inputs[:resolve]
    )

    op.perform

    if op.succeeded?
      { success: true }
    else
      { success: false }
    end
  })
end
