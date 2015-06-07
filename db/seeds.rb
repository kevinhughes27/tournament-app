# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

CSV.foreach(File.join(Rails.root, "template.csv"), :headers => true, :encoding => 'UTF-8') do |row|
team = Team.create([{
  name: row[0],
  email: row[1],
  division: row[2],
  tournament_id: '1'
}])
end