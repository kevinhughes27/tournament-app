class Resolvers::SettingsUpdate < Resolver
  SETTINGS_UPDATE_CONFIRM_MSG = """Changing your handle will change the web url of your tournament.\
 If you have distributed this link anywhere it will no longer work."""

  def call(inputs, ctx)
    tournament = ctx[:tournament]
    params = inputs.to_h.except('confirm')

    if changing_handle?(tournament, params) && !inputs[:confirm]
      tournament.assign_attributes(params)
      return {
        success: false,
        confirm: true,
        errors: [SETTINGS_UPDATE_CONFIRM_MSG]
      }
    end

    if tournament.update(params)
      { success: true }
    else
      { success: false, errors: tournament.errors.full_messages }
    end
  end

  def changing_handle?(tournament, params)
    params['handle'] && tournament.handle != params['handle']
  end
end
