class Types::ScoreDispute < Types::BaseObject
  graphql_name "ScoreDispute"
  description "A Score Dispute"

  field :id, ID, null: false
  field :gameId, Int, null: false
end
