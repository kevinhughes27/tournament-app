class Types::Game < Types::BaseObject
  graphql_name "Game"
  description "A Game"

  global_id_field :id
  field :division, Types::Division, null: true
  field :pool, String, null: true
  field :bracketUid, String, null: true
  field :round, String, null: true

  field :homeName, String, null: true
  field :awayName, String, null: true
  field :homePrereq, String, null: true
  field :awayPrereq, String, null: true
  field :homePoolSeed, Int, null: true
  field :awayPoolSeed, Int, null: true

  field :field, Types::Field, null: true
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
