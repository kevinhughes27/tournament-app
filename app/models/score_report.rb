class ScoreReport < ApplicationRecord
  belongs_to :tournament
  belongs_to :game
  belongs_to :team

  has_one :score_report_confirm_token

  acts_as_paranoid

  validates_presence_of :tournament,
                        :game,
                        :team,
                        :submitter_fingerprint,
                        :team_score,
                        :opponent_score

  validates_numericality_of :team_score, :opponent_score, greater_than_or_equal_to: 0

  def ==(other)
    if self.team_id == other.team_id
      self.team_score == other.team_score &&
      self.opponent_score == other.opponent_score
    else
      self.team_score == other.opponent_score &&
      self.opponent_score == other.team_score
    end
  end
  alias_method :eql?, :==

  def submitted_by
    team.name
  end

  def confirm_token
    score_report_confirm_token
  end

  def submitter_won?
    if team == game.home
      home_score > away_score
    else
      away_score > home_score
    end
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

  def other_team
    if team == game.home
      game.away
    else
      game.home
    end
  end

  def sotg_score
    [rules_knowledge, fouls, fairness, attitude, communication].join("-")
  end

  def sotg_warning?
    [rules_knowledge, fouls, fairness, attitude, communication].any?{ |v| v < 2 }
  end

  def total
    rules_knowledge + fouls + fairness + attitude + communication
  end
end
