class FieldDropPolyAddGeoJson < ActiveRecord::Migration
  def change
    remove_column :fields, :polygon
    add_column :fields, :geo_json, :string
  end
end
