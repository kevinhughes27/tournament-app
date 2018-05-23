class Types::Game < Types::BaseObject
  graphql_name "Game"
  description "A Game"

  field :id, ID, null: false
  field :homeName, String, null: true
  field :awayName, String, null: true
  field :fieldId, ID, null: true
  field :fieldName, String, null: true
  field :startTime, Types::DateTime, null: true
  field :endTime, Types::DateTime, null: true
  field :homeScore, Int, null: true
  field :awayScore, Int, null: true
  field :scoreConfirmed, Boolean, null: false do
    description("True when a score has been submitted and
     accepted by the tournament as confirmed according to its rules.
     Some tournament require a submission from both teams or a validated
     confirmation.")
  end
end
