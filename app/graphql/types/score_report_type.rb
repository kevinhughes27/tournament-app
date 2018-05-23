ScoreReportType = GraphQL::ObjectType.define do
  name "ScoreReport"
  description "A ScoreReport"
  field :id, types.ID
  field :team, TeamType
  field :submitter_fingerprint, types.String
  field :home_score, types.Int
  field :away_score, types.Int
  field :opponent_score, types.Int
  field :rules_knowledge, types.Int
  field :fouls, types.Int
  field :fairness, types.Int
  field :attitude, types.Int
  field :communication, types.Int
  field :comment, types.String
end
