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
  return_field :confirm, types.Boolean
  return_field :not_allowed, types.Boolean
  return_field :errors, types[types.String]
  return_field :team, TeamType

  resolve(Auth.protect -> (obj, inputs, ctx) {
    team = ctx[:tournament].teams.find(inputs[:team_id])
    params = inputs.to_h.except('team_id', 'confirm')

    op = TeamUpdate.new(team, params, confirm: inputs[:confirm])

    op.perform

    if op.succeeded?
      {
        success: true,
        team: team
      }
    elsif op.confirmation_required?
      {
        success: false,
        confirm: true,
        errors: ["There are games scheduled for this team. Updating the team may unassign it from those games. You will need to re-seed the #{team.division.name} division."],
        team: team
      }
    elsif op.not_allowed?
      {
        success: false,
        not_allowed: true,
        errors: ["There are games in this team's division that have been scored. In order to update this team you need to delete the #{team.division.name} division first."],
        team: team
      }
    else
      {
        success: false,
        errors: team.errors.full_messages,
        team: team
      }
    end
  })
end
