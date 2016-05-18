class AddWelcomeEmailSentCol < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :welcome_email_sent, :boolean, default: false
  end
end
