class ConfirmedBooleanFix < ActiveRecord::Migration[5.0]
  def change
    Game.where(score_confirmed: nil).update_all(score_confirmed: false)
    change_column :games, :score_confirmed, :boolean, default: false, null: false
  end
end
