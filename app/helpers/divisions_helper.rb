module DivisionsHelper
  def bracket_options(division)
    brackets = BracketDb.where(teams: division.num_teams, days: division.num_days).map do |handle, bracket|
      [bracket.name, handle]
    end

    options_for_select(brackets, division.bracket.try(:handle))
  end
end
