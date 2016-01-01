namespace :tournament do
  desc "Creates a tournament. Parameters: NAME"
  task :create => :environment do
    name = ENV['NAME']
    handle = name.underscore.dasherize

    tournament = Tournament.create!(
      name: name,
      handle: handle,
      time_cap: 90
    )

    tournament.create_map!(
      lat: 45.2457399303424,
      long: -75.6146840751171,
      zoom: 16
    )

    puts "done!"
  end
end
