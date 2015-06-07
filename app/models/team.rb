class Team < ActiveRecord::Base
	belongs_to :tournament
  has_and_belongs_to_many :spirits

	def self.import(file, id)
	require 'csv'
  CSV.foreach(file.path, headers: true) do |row|
    team = Team.create([{
  	name: row[0],
  	email: row[1],
  	division: row[2],
  	tournament_id: params[:touranment_id]
	}])
  end
end

end
