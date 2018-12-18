require 'csv'

class ReBackfillSeeds < ActiveRecord::Migration[5.2]
  def change
    if Rails.env.production?
      CSV.foreach("#{Rails.root}/db/migrate/teams.csv", headers: true) do |row|
        if row['division_id'].present? && row['seed'].present?
          Seed.create!(
            tournament_id: row['tournament_id'],
            division_id: row['division_id'],
            team_id: row['team_id'],
            rank: row['seed']
          )
        end
      end
    end
  end
end
