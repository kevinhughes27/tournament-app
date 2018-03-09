class OnlyFullBrackets < ActiveRecord::Migration[5.0]
  def change
    update_bracket_type('USAU 24.1 full', 'USAU 24.1')
    update_bracket_type('USAU 23.1 full', 'USAU 23.1')
    update_bracket_type('USAU 16.1 full', 'USAU 16.1')
  end

  def update_bracket_type(old_type, new_type)
    Division.where(bracket_type: old_type)
      .update_all(bracket_type: new_type)
  end
end
