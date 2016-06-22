class AddConfirmSetting < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :game_confirm_setting, :string, default: 'automatic'
  end
end
