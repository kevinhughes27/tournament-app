GameScheduleMutation = GraphQL::Relay::Mutation.define do
  name "GameSchedule"

  input_field :game_id, types.ID
  input_field :field_id, types.ID
  input_field :start_time, types.String
  input_field :end_time, types.String

  return_field :success, !types.Boolean
  return_field :errors, types[types.String]
  return_field :game, GameType

  resolve(Auth.protect -> (obj, inputs, ctx) {
    game = ctx[:tournament].games
      .includes(:division, :home, :away)
      .find(inputs[:game_id])

    op = GameSchedule.new(
      game,
      inputs[:field_id],
      inputs[:start_time],
      inputs[:end_time]
    )

    begin
      op.perform
      { success: true, game: game }
    rescue => e
      { success: false, errors: [e.message], game: game }
    end
  })
end
