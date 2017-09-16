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
                        :home_score,
                        :away_score

  validates_numericality_of :home_score, :away_score, greater_than_or_equal_to: 0

  def ==(other)
    self.home_score == other.home_score &&
    self.away_score == other.away_score
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
