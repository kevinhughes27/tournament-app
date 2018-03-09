class DropConfirmTokens < ActiveRecord::Migration[5.0]
  def change
    drop_table :score_report_confirm_tokens
  end
end
