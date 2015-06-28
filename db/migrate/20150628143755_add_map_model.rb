class AddMapModel < ActiveRecord::Migration

  def change
    create_table :maps do |t|
      t.integer :tournament_id
      t.decimal :lat,  :precision => 15, :scale => 10, :default => 56, null: false
      t.decimal :long, :precision => 15, :scale => 10, :default => -96, null: false
      t.integer :zoom, :default => 4, null: false
    end

    Tournament.all.each do |t|
      t.build_map(lat: t.lat, long: t.long, zoom: t.zoom).save!
    end

    remove_column :tournaments, :lat
    remove_column :tournaments, :long
    remove_column :tournaments, :zoom
  end

end
