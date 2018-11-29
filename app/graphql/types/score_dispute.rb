class Types::ScoreDispute < Types::BaseObject
  graphql_name "ScoreDispute"
  description "A Score Dispute"

  global_id_field :id
  field :gameId, ID, null: false
end
