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

  after_create :notify_other_team
  after_create :confirm_game
  after_create :touch_game

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

  private

  def notify_other_team
    return if is_confirmation?

    token = ScoreReportConfirmToken.create!({
      tournament_id: tournament_id,
      score_report_id: id
    })

    ScoreReportMailer.notify_team_email(other_team, team, self, token).deliver_later
  end

  def confirm_game
    if is_confirmation?
      Games::UpdateScoreJob.perform_later(
        game: game,
        home_score: home_score,
        away_score: away_score,
        force: true
      )
    end
  end

  def touch_game
    game.update_attributes(updated_at: Time.now)
  end
end
