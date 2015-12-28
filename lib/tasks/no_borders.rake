namespace :nobo do
  desc "Creates the nobo from 2015 blank"
  task :create => :environment do
    tournament = Tournament.create!(
      name: 'No Borders',
      handle: 'no-borders',
      time_cap: 90
    )

    tournament.create_map!(
      lat: 45.2457399303424,
      long: -75.6146840751171,
      zoom: 16
    )
  end
end
