module DivisionsHelper
  def bracket_options(division)
    options_for_select(
      Bracket.where(num_teams: division.num_teams, days: division.num_days).pluck(:name, :handle),
      division.bracket.try(:name)
    )
  end
end
