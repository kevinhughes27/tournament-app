task dump_timezones: :environment do
  path = "clients/admin_next/src/views/Settings/Timezones.ts"

  zones = ActiveSupport::TimeZone.all.map do |zone|
    [zone.to_s, zone.tzinfo.name]
  end

  output = "export default " + JSON.pretty_generate(zones) + ";"

  File.write(Rails.root.join(path), output)
  puts "Updated #{path}"
end
