class UpdateGames < ActiveRecord::Migration[5.0]
  def change
    Rake::Task["m:update_bracket_games"].invoke
  end
end
