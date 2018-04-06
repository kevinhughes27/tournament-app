TeamUpdateMutation = GraphQL::Relay::Mutation.define do
  name "TeamUpdate"

  input_field :team_id, types.ID
  input_field :name, types.String
  input_field :email, types.String
  input_field :phone, types.String
  input_field :division_id, types.ID
  input_field :seed, types.Int
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean

  resolve(Auth.protect -> (obj, inputs, ctx) {
    team = ctx[:tournament].teams.find(inputs[:team_id])
    params = inputs.to_h.except(:team_id, :confirm)

    op = TeamUpdate.new(team, params, confirm: inputs[:confirm])

    op.perform

    if op.succeeded?
      { success: true }
    elsif op.confirmation_required?
      { success: false }
    elsif op.not_allowed?
      { success: false }
    else
      { success: false }
    end
  })
end
