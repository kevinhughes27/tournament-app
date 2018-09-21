class Resolvers::UpdateSettings < Resolvers::BaseResolver
  SETTINGS_UPDATE_CONFIRM_MSG = """Changing your handle will change the web url of your tournament.\
 If you have distributed this link anywhere it will no longer work."""

  def call(inputs, ctx)
    tournament = ctx[:tournament]
    params = inputs.to_h.except(:confirm)

    if changing_handle?(tournament, params) && !inputs[:confirm]
      tournament.assign_attributes(params)
      return {
        success: false,
        confirm: true,
        message: SETTINGS_UPDATE_CONFIRM_MSG
      }
    end
    if tournament.update(params)
      {
        success: true,
        message: 'Settings updated'
      }
    else
      {
        success: false,
        user_errors: tournament.fields_errors
      }
    end
  end

  def changing_handle?(tournament, params)
    params[:handle] && tournament.handle != params[:handle]
  end
end
