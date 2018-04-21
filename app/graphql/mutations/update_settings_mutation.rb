UpdateSettingsMutation = GraphQL::Relay::Mutation.define do
  name "UpdateSettings"

  input_field :name, types.String
  input_field :handle, types.String
  input_field :score_submit_pin, types.String
  input_field :game_confirm_setting, types.String
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean

  resolve(Auth.protect -> (obj, inputs, ctx) {
    params = inputs.to_h.except('confirm')

    op = UpdateSettings.new(
      tournament: ctx[:tournament],
      params: params,
      confirm: inputs[:confirm]
    )

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
