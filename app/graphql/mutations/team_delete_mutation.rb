TeamDeleteMutation = GraphQL::Relay::Mutation.define do
  name "TeamDelete"

  input_field :team_id, types.ID
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean

  resolve(Auth.protect -> (obj, inputs, ctx) {
    team = ctx[:tournament].teams.find(inputs[:team_id])

    op = TeamDelete.new(team, confirm: inputs[:confirm])

    op.perform

    if op.succeeded?
      { success: true }
    elsif op.confirmation_required?
      { success: false }
    else
      { success: false }
    end
  })
end
