class ScoreReport < ApplicationRecord
  belongs_to :tournament
  belongs_to :game
  belongs_to :team

  acts_as_paranoid
  has_paper_trail on: [:update]

  validates_presence_of :submitter_fingerprint,
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

  def build_confirm_link
    params = {
      teamName: other_team.name,
      gameId: game_id,
      homeScore: home_score,
      awayScore: away_score
    }

    "#{tournament.url}/submit?#{params.to_query}"
  end

  def build_dispute_link
    params = {
      teamName: other_team.name,
      gameId: game_id
    }

    "#{tournament.url}/submit?#{params.to_query}"
  end
end
