namespace :dev do
  namespace :score_reports do
    desc "Generates score reports. Parameters: TOURNAMENT, DIVISION and ROUND."
    task :generate => :environment do
      handle = ENV['TOURNAMENT']
      division_name = ENV['DIVISION'].gsub('_', ' ')
      round = ENV['ROUND'].to_i

      puts "creating score reports for tournament: #{handle} division: #{division_name}, round: #{round}"

      tournament = Tournament.find_by!(handle: handle)
      division = tournament.divisions.find_by!(name: division_name)
      bracket = division.bracket
      bracket_uids = bracket.game_uids_for_round(round)

      games = division.games.where(bracket_uid: bracket_uids)

      unless games.all?{ |g| g.teams_present? }
        abort("Can't create score reports for games without teams")
      end

      games.each do |game|
        score = ScoreGenerator.new.score
        report = ScoreReport.create!(
          tournament: tournament,
          game: game,
          team: game.home,
          submitter_fingerprint: 'rake:task',
          team_score: score[0],
          opponent_score: score[1],
          rules_knowledge: 3,
          fouls: 3,
          fairness: 3,
          attitude: 3,
          communication: 3,
        )
        puts report
      end
    end
  end
end
