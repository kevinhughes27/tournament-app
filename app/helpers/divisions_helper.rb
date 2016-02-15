module DivisionsHelper
  def bracket_options(num_teams)
    options_for_select Bracket.where(num_teams: num_teams).pluck(:name) #form.object.bracket_type
  end
end
