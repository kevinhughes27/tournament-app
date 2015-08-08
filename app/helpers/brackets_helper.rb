module BracketsHelper
  # could take divison and/or teams as arg
  def bracket_select
    select_tag 'bracket_type', options_for_select(Bracket.types)
  end
end
