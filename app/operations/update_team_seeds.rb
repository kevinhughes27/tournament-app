class UpdateTeamSeeds < ComposableOperations::Operation
  processes :division, :team_ids, :seeds
  property :division, accepts: Division, required: true
  property :team_ids, accepts: Array, required: true
  property :seeds, accepts: Array, required: true

  def execute
    Team.transaction do
      team_ids.each_with_index do |team_id, idx|
        team = teams.detect { |t| t.id == team_id.to_i}
        team.assign_attributes(seed: seeds[idx])
        raise if team.seed_changed? && !team.allow_change?
        team.save!
      end
    end
  rescue StandardError => e
    fail e.message
  end

  private

  def teams
    @teams ||= division.teams
  end
end
