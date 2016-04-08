class AddScoreReportConfirmToken < ActiveRecord::Migration
  def change
    create_table :score_report_confirm_tokens do |t|
      t.integer :tournament_id, null: false
      t.integer :score_report_id, null: false
      t.string :token, null: false
      t.index [:token]
    end
  end
end
