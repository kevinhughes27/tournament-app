class ScoreReport < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :game
  belongs_to :team

  validates_presence_of :tournament,
                        :game,
                        :team,
                        :submitter_fingerprint,
                        :team_score,
                        :opponent_score

  validates_numericality_of :team_score, :opponent_score

  def submitted_by
    team.name
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

  def sotg_score
    [rules_knowledge, fouls, fairness, attitude, communication].join("-")
  end

  def sotg_warning?
    [rules_knowledge, fouls, fairness, attitude, communication].any?{ |v| v < 2 }
  end
end
