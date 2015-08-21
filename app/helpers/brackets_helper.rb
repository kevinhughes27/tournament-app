module BracketsHelper
  def bracket_options(num_teams)
    options_for_select BracketDb.templates_for(num_teams).keys #form.object.bracket_type
  end

  def pretty_print_template(template)
    template[:games].join("\n")
  end
end
