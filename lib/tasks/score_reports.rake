namespace :score_reports do
  desc "Generates score reports. Parameters: TOURNAMENT, DIVISION and ROUND."
  task :generate => :environment do
    tournament_id = ENV['TOURNAMENT']
    division = ENV['DIVISION']
    round = ENV['ROUND'].to_i

    tournament = Tournament.friendly.find(tournament_id)
    bracket = tournament.brackets.find_by!(division: division)
    bracket_uids = bracket.bracket_uids_for_round(round)

    games = bracket.games.where(bracket_uid: bracket_uids)

    unless games.all?{ |g| g.teams_present? }
      abort("Can't create score reports for games without teams")
    end

    games.each do |game|
      score = ScoreGenerator.new.score
      ScoreReport.create!(
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
    end
  end
end
