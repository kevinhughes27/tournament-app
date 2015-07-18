class ScoreReport < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :game
  belongs_to :team

  def game_name
    "#{game.home.name} vs #{game.away.name}"
  end

  def score
    "#{home_score} - #{away_score}"
  end

  def home_score
    if team == game.home
      team_score
    else
      opponent_score
    end
  end

  def away_score
    if team == game.home
      opponent_score
    else
      team_score
    end
  end

  def submitted_by
    team.name
  end

end
