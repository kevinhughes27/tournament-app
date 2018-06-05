module DivisionsHelper
  def bracket_options(division)
    options_for_select(
      BracketDb.where(teams: division.num_teams, days: division.num_days).map { |b| [b.name, b.handle] },
      division.bracket.try(:handle)
    )
  end
end
