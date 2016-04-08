class AddIsConfirmationToReport < ActiveRecord::Migration
  def change
    add_column :score_reports, :is_confirmation, :boolean, default: false
  end
end
