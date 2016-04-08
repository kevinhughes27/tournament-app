class AddScoreReportConfirmToken < ActiveRecord::Migration
  def change
    create_table :score_report_confirm_tokens do |t|
      t.integer :tournament_id
      t.integer :score_report_id
      t.string :token
      t.index [:token]
    end
  end
end
