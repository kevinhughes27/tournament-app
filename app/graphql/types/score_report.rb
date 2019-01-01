class Types::ScoreReport < Types::BaseObject
  graphql_name "ScoreReport"
  description "A Score Report"

  field :id, ID, null: false
  field :submittedBy, String, null: false
  field :submitterFingerprint, String, null: false
  field :homeScore, Int, null: false
  field :awayScore, Int, null: false
  field :rulesKnowledge, Int, null: false
  field :fouls, Int, null: false
  field :fairness, Int, null: false
  field :attitude, Int, null: false
  field :communication, Int, null: false
  field :comments, String, null: true

  def submitted_by
    BatchLoader.for(object.team_id).batch do |team_ids, loader|
      Team.where(id: team_ids).each { |team| loader.call(team.id, team.name) }
    end
  end
end
