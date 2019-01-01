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
    home.present? && away.present?
  end

  def home_name
    home.present? ? home.name : object.home_prereq
  end

  def away_name
    away.present? ? away.name : object.away_prereq
  end

  def home
    BatchLoader.for(object.home_id).batch do |team_ids, loader|
      Team.where(id: team_ids).each { |team| loader.call(team.id, team) }
    end
  end

  def away
    BatchLoader.for(object.away_id).batch do |team_ids, loader|
      Team.where(id: team_ids).each { |team| loader.call(team.id, team) }
    end
  end

  def division
    BatchLoader.for(object.division_id).batch do |division_ids, loader|
      Division.where(id: division_ids).each { |division| loader.call(division.id, division) }
    end
  end

  def field
    BatchLoader.for(object.field_id).batch do |field_ids, loader|
      Division.where(id: field_ids).each { |field| loader.call(field.id, field) }
    end
  end

  def score_reports
    BatchLoader.for(object.id).batch(default_value: []) do |game_ids, loader|
      ScoreReport.where(game_id: game_ids).each do |report|
        loader.call(report.game_id) { |reports| reports << report }
      end
    end
  end

  def score_disputed
    BatchLoader.for(object.id).batch(default_value: false) do |game_ids, loader|
      ScoreDispute.where(game_id: game_ids).each do |dispute|
        loader.call(dispute.game_id)
      end
    end
  end
end
