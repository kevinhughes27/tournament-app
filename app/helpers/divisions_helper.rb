module DivisionsHelper
  def bracket_options(division)
    options_for_select(
      Bracket.where(num_teams: division.num_teams).pluck(:name),
      division.bracket.name
    )
  end
end
