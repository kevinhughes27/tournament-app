TeamDeleteMutation = GraphQL::Relay::Mutation.define do
  name "TeamDelete"

  input_field :team_id, types.ID
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean
  return_field :confirm, types.Boolean
  return_field :not_allowed, types.Boolean
  return_field :errors, types[types.String]

  resolve(Auth.protect -> (obj, inputs, ctx) {
    team = ctx[:tournament].teams.find(inputs[:team_id])

    op = TeamDelete.new(team, confirm: inputs[:confirm])

    op.perform

    if op.succeeded?
      { success: true }
    elsif op.confirmation_required?
      {
        success: false,
        confirm: true,
        errors: ["There are games scheduled for this team. Deleting the team will unassign it from those games. You will need to re-seed the #{team.division.name} division."]
      }
    elsif op.halted?
      {
        success: false,
        not_allowed: true,
        errors: ["There are games in this team's division that have been scored. In order to delete this team you need to delete the #{team.division.name} division first."]
      }
    else
      { success: false }
    end
  })
end
