GameScheduleMutation = GraphQL::Relay::Mutation.define do
  name "GameSchedule"

  input_field :game_id, types.ID
  input_field :field_id, types.ID
  input_field :start_time, types.String
  input_field :end_time, types.String

  return_field :success, !types.Boolean

  resolve(Auth.protect -> (obj, inputs, ctx) {
    game = ctx[:tournament].games.find(inputs[:game_id])

    op = GameSchedule.new(
      game,
      inputs[:field_id],
      inputs[:start_time],
      inputs[:end_time]
    )

    op.perform

    if op.succeeded?
      { success: true }
    else
      { success: false }
    end
  })
end
