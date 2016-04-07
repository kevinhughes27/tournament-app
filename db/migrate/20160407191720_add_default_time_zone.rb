class AddDefaultTimeZone < ActiveRecord::Migration
  def change
    add_column :tournaments, :timezone, :string
  end
end
