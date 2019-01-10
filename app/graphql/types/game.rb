class Types::Game < Types::BaseObject
  graphql_name "Game"
  description "A Game"

  field :id, ID, null: false
  field :division, Types::Division, null: false
  field :pool, String, null: true
  field :bracketUid, String, null: true
  field :round, Int, null: false

  field :homeName, String, null: true
  field :awayName, String, null: true
  field :homePrereq, String, null: false
  field :awayPrereq, String, null: false
  field :homePoolSeed, Int, null: true
  field :awayPoolSeed, Int, null: true
  field :hasTeams, Boolean, null: false

  field :field, Types::Field, null: true
  field :startTime, Types::DateTime, null: true
  field :endTime, Types::DateTime, null: true
  field :scheduled, Boolean, null: false

  field :homeScore, Int, null: true
  field :awayScore, Int, null: true
  field :scoreConfirmed, Boolean, null: false do
    description("True when a score has been submitted and
     accepted by the tournament as confirmed according to its rules.
     Some tournament require a submission from both teams or a validated
     confirmation.")
  end
  field :scoreReports, [Types::ScoreReport], null: true
  field :scoreDisputed, Boolean, null: false

  def scheduled
    object.scheduled?
  end

  def has_teams
    RecordLoader.for(::Team).load(object.home_id).then do |home|
      RecordLoader.for(::Team).load(object.away_id).then do |away|
        home.present? && away.present?
      end
    end
  end

   def home_name
     RecordLoader.for(::Team).load(object.home_id).then do |home|
       home.present? ? home.name : object.home_prereq
     end
  end

  def away_name
    RecordLoader.for(::Team).load(object.away_id).then do |away|
      away.present? ? away.name : object.away_prereq
    end
  end

  def division
    RecordLoader.for(::Division).load(object.division_id)
  end

  def field
    RecordLoader.for(::Field).load(object.field_id)
  end

  def score_reports
    AssociationLoader.for(::Game, :score_reports).load(object).then do |reports|
      reports
    end
  end

  def score_disputed
    AssociationLoader.for(::Game, :score_disputes).load(object).then do |disputes|
      disputes.present?
    end
  end
end
