DivisionUpdateMutation = GraphQL::Relay::Mutation.define do
  name "DivisionUpdate"

  input_field :division_id, types.ID
  input_field :name, types.String
  input_field :num_teams, types.Int
  input_field :num_days, types.Int
  input_field :bracket_type, types.String
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean

  resolve(Auth.protect -> (obj, inputs, ctx) {
    division = ctx[:tournament].divisions.find(inputs[:division_id])
    params = inputs.to_h.except('division_id', 'confirm')

    op = DivisionUpdate.new(division, params, confirm: inputs[:confirm])

    begin
      op.perform
    rescue => e
      return { success: false }
    end

    if op.succeeded?
      { success: true }
    elsif op.confirmation_required?
      { success: false }
    else
      { success: false }
    end
  })
end
