module SettingsHelper
  def timezone_options(tournament)
    zones = ActiveSupport::TimeZone.all.map do |zone|
      [zone.to_s, zone.name]
    end

    options_for_select(zones, tournament.timezone)
  end
end
