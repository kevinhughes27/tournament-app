class RemoveValidatedSetting < ActiveRecord::Migration[5.0]
  def change
    change_column :tournaments, :game_confirm_setting, :string, default: 'single'

    Tournament.where(game_confirm_setting: 'automatic').update_all(
      game_confirm_setting: 'single'
    )

    Tournament.where(game_confirm_setting: 'validated').update_all(
      game_confirm_setting: 'multiple'
    )
  end
end
