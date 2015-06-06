class CreateGameJoinTable < ActiveRecord::Migration
  def change
    create_join_table :games, :teams do |t|
      # t.index [:game_id, :team_id]
      # t.index [:team_id, :game_id]
      t.index [:game_id, :team_id], unique: true, name: 'game_team_join_index'
    end
  end
end
