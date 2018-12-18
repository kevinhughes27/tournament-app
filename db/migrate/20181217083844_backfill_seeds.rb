class BackfillSeeds < ActiveRecord::Migration[5.2]
  def change
    Team.find_each do |team|
      backfill_seed(team) if team.division_id.present? && team.seed.present?
    end
  end

  def backfill_seed(team)
    Seed.create!(
      tournament_id: team.tournament_id,
      division_id: team.division_id,
      team_id: team.id,
      seed: team.seed
    )
  end
end
