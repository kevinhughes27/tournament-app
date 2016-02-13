module DivisionsHelper
  def bracket_options(num_teams)
    options_for_select BracketDb.templates_for(num_teams).keys #form.object.bracket_type
  end
end
