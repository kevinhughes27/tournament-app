SettingsUpdateMutation = GraphQL::Relay::Mutation.define do
  name "SettingsUpdate"

  input_field :name, types.String
  input_field :handle, types.String
  input_field :score_submit_pin, types.String
  input_field :game_confirm_setting, types.String
  input_field :timezone, types.String
  input_field :confirm, types.Boolean

  return_field :success, !types.Boolean
  return_field :confirm, types.Boolean
  return_field :errors, types[types.String]

  resolve(Auth.protect -> (obj, inputs, ctx) {
    tournament = ctx[:tournament]
    params = inputs.to_h.except('confirm')

    op = UpdateSettings.new(
      tournament: tournament,
      params: params,
      confirm: inputs[:confirm]
    )

    op.perform

    if op.succeeded?
      { success: true }
    elsif op.confirmation_required?
      {
        success: false,
        confirm: true,
        errors: ["Changing your handle will change the web url of your tournament. If you have distributed this link anywhere it will no longer work."]
      }
    else
      { success: false, errors: tournament.errors.full_messages }
    end
  })
end
