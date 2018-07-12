module SettingsHelper
  def timezone_options(tournament)
    zones = ActiveSupport::TimeZone.all.map do |zone|
      [zone.to_s, zone.name]
    end

    zone = Time.find_zone(tournament.timezone)

    rails_zone = ActiveSupport::TimeZone::MAPPING.find do |short_name, full_name|
      zone.name == full_name
    end

    selected = if rails_zone
      rails_zone[0]
    else
      zone.name
    end

    options_for_select(zones, selected)
  end
end
