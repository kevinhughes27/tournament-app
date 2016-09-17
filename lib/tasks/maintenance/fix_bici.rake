namespace :m do
  task :fix_bici => :environment do
    division = Division.find(67)
    division.bracket_games.destroy_all

    template_games = division.template[:games].select{ |game| game[:bracket_uid] }
    template_games.each do |template_game|
      Game::create_from_template!(
        tournament_id: division.tournament_id,
        division_id: division.id,
        template_game: template_game
      )
    end

    division.pools.each do |pool|
      FinishPool.perform(pool)
    end
  end
end
