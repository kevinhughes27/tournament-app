class CreateSpiritsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :spirits, :teams do |t|
      # t.index [:spirit_id, :team_id]
      # t.index [:team_id, :spirit_id]
      t.index [:spirit_id, :team_id], name: 'spirits_teams_join_index'
    end
  end
end
