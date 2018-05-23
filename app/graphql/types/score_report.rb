class Types::ScoreReport < Types::BaseObject
  graphql_name "ScoreReport"
  description "A ScoreReport"

  field :id, ID, null: false
  field :team, Types::Team, null: false
  field :submitterFingerprint, String, null: false
  field :homeScore, Int, null: false
  field :awayScore, Int, null: false
  field :rulesKnowledge, Int, null: false
  field :fouls, Int, null: false
  field :fairness, Int, null: false
  field :attitude, Int, null: false
  field :communication, Int, null: false
  field :comment, String, null: true
end
