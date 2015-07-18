class ScoreReport < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :game
  belongs_to :team

  def game_name
    "#{game.home.name} vs #{game.away.name}"
  end

  def score
    if team == game.home
      "#{team_score} - #{opponent_score}"
    else
      "#{opponent_score} - #{team_score}"
    end
  end

  def submitted_by
    team.name
  end

end
