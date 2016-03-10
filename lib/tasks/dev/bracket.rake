namespace :dev do
  namespace :bracket do
    desc "Advances the bracketby assigning random winners. Parameters: TOURNAMENT, DIVISION and ROUND"
    task :advance => :environment do
      tournament_id = ENV['TOURNAMENT']
      division = ENV['DIVISION'].gsub('_', ' ')
      round = ENV['ROUND'].to_i

      puts "advancing bracket for tournament: #{tournament_id} division: #{division}, round: #{round}"

      tournament = Tournament.friendly.find(tournament_id)
      bracket = tournament.brackets.find_by!(division: division)
      bracket_uids = bracket.bracket_uids_for_round(round)

      games = bracket.games.where(bracket_uid: bracket_uids)

      unless games.all?{ |g| g.teams_present? }
        abort("Can't advance bracket round unless all games have teams")
      end

      games.each do |game|
        score = ScoreGenerator.new.score
        game.update_score(score[0], score[1])
        puts game
      end
    end
  end
end
