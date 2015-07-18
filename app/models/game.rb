class Game < ActiveRecord::Base
  include UpdateSet
  belongs_to :field
  belongs_to :tournament
  belongs_to :home, :class_name => "Team", :foreign_key => :home_id
  belongs_to :away, :class_name => "Team", :foreign_key => :away_id

  def unconfirmed?
    !score_confirmed
  end

  def confirm_score(home_score, away_score)
    update_attributes(
      home_score: home_score,
      away_score: away_score,
      score_confirmed: true
    )
  end

end
