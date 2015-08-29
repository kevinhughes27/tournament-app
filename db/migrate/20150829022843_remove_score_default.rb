class RemoveScoreDefault < ActiveRecord::Migration
  def change
    change_column_default(:games, :home_score, nil)
    change_column_default(:games, :away_score, nil)
  end
end
