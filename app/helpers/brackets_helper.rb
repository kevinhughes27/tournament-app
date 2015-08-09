module BracketsHelper
  # could take divison and/or teams as arg
  def bracket_select(form, options)
    form.select(
      :bracket_type,
      options_for_select(Bracket.types, form.object.bracket_type),
      {},
      options
    )
  end
end
