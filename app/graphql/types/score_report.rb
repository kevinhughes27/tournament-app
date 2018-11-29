class Types::ScoreReport < Types::BaseObject
  graphql_name "ScoreReport"
  description "A Score Report"

  global_id_field :id

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
end
