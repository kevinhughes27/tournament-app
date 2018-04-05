class SetTeamsDivision < ApplicationOperation
  input :tournament, accepts: Tournament, required: true
  input :ids, type: :keyword, required: true
  input :arg, type: :keyword, required: true

  attr_reader :teams

  def execute
    if teams.all? {|t| t.safe_to_change? }
      teams.update_all(division_id: division.id)
      teams.reload
    else
      halt 'Cancelled: not all teams could be updated safely'
    end
  end

  def teams
    @teams ||= Team.where(id: ids)
  end

  def division
    @division ||= Division.find_by(tournament: tournament, name: arg)
  end
end
