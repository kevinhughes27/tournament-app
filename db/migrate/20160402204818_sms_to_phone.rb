class SmsToPhone < ActiveRecord::Migration
  def change
    rename_column :teams, :sms, :phone
  end
end
